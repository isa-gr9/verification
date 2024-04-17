class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    packet_in tr_in;
    packet_out tr_out;
    shortreal result;

    uvm_get_port #(packet_in) in;
    uvm_put_port #(packet_out) out;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = packet_out::type_id::create("tr_out", this);

    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        forever begin
            in.get(tr_in);
            result = tr_in.Ashort * tr_in.Bshort;
            tr_out.data = ieee754(result);

            $display("refmod: input A = %d, input B = %d, output OUT = %d",tr_in.A, tr_in.B, tr_out.data);
			$display("refmod: input A = %b, input B = %b, output OUT = %b",tr_in.A, tr_in.B, tr_out.data);
            out.put(tr_out);
        end
    endtask: run_phase



    function logic [15:0] ieee754 (input shortreal float32); //, output logic[15:0] ieee754);
        logic [9:0]     mantissa        = 'b0;
        logic [4:0]     exp_bin         = 'b0;
        logic           sign;
        int             i               = 0;
        logic [15:0]    tmp_mantissa;
        int             exp_bias        = 0;
        int             exp_int         = 0;
        int             integer_part;
        shortreal       fractional_part;
        int             j;
        int             tmp_int;

        // initial begin
            integer_part        = $floor(float32);
            fractional_part     = float32 - $floor(float32);
            sign                = (integer_part >> 31) & 1'b1;

            if (sign) begin
                integer_part    = -integer_part;
                fractional_part = -fractional_part;
            end

            while(integer_part > 0) begin
                tmp_mantissa[i] = integer_part & 1'b1;
                integer_part >>= 1; 
                i++;
            end

            exp_bias    = i-1;
            exp_int     = 15+exp_bias;

            for(j=0; j<exp_bias; j++) begin
                mantissa[j] = tmp_mantissa[exp_bias-1-j];
            end

            while (fractional_part != 0.0 && j < 11) begin
                fractional_part *= 2;

                if (fractional_part > 0.99 && fractional_part < 1)
                    fractional_part = 1;

                if (fractional_part >= 1)
                    mantissa[j] = 1'b1;
                else
                    mantissa[j] = 1'b0;

                j++;

                if (fractional_part >= 1 )
                    fractional_part -= 1;
            end

            i = 0;

            while(exp_int > 0) begin
                exp_bin[i] = exp_int & 1'b1;
                exp_int >>= 1; 
                i++;
            end

            ieee754[15] = sign;

            for (i = 0; i < 5; i++) begin
                ieee754[14 - i] = exp_bin[5 - 1 - i];
            end

            for (i = 0; i < 10; i++) begin
                ieee754[9 - i] = mantissa[i];
            end

        // end

        return ieee754;
    endfunction


endclass: refmod
