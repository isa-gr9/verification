class packet_in extends uvm_sequence_item;
    rand int            Aint;
    rand int            Bint;
    shortreal           Ashort;
    shortreal           Bshort;
    logic [15:0]        A;
    logic [15:0]        B;



    `uvm_object_utils_begin(packet_in)
        `uvm_field_int(Aint, UVM_ALL_ON|UVM_HEX)
        `uvm_field_int(Bint, UVM_ALL_ON|UVM_HEX)
        `uvm_field_real(Bshort, UVM_ALL_ON|UVM_HEX)
        `uvm_field_real(Bshort, UVM_ALL_ON|UVM_HEX)
    `uvm_object_utils_end


    function new(string name="packet_in");
        super.new(name);
    endfunction: new

    constraint a {Aint < 10000; Aint > -10000; Bint < 10000; Bint > -10000;}

    function void post_randomize();
        Ashort = (shortreal'(Aint)/10.0);
        Bshort = (shortreal'(Bint)/10.0);
        A = ieee754(Ashort);
        B = ieee754(Bshort);
        `uvm_info(get_type_name(), $sformatf("Aint=%0d, Ashort=%0.4f, A=%0b , Bshort=%0.4f, B=%0b",Aint, Ashort, A, Bshort, B), UVM_NONE);
    endfunction



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


endclass: packet_in
