  
  
  
  

function f2ieee754 (input shortreal float32, output logic[15:0] ieee754);
    logic [9:0]     mantissa; //       = 'b0;
    logic [4:0]     exp_bin; //         = 'b0;
    logic           sign;
    int             i; //               = 0;
    logic [15:0]    tmp_mantissa;
    int             exp_bias; //        = 0;
    int             exp_int; //         = 0;
    int             integer_part;
    shortreal       fractional_part;
    int             j;
    int             tmp_int;

    initial begin
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

    end
endfunction
  
  
  
  
  
  
  
  
  
  
  
  
  module test();

    shortreal       float32;

    bit [15:0]    ieee754         = 'b0;
    logic [9:0]    mantissa        = 'b0;
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
    shortreal       prova;

  initial begin

    float32 = 7.80078;


    integer_part        = $floor(float32);
    fractional_part     = float32 - $floor(float32);
    sign                = (integer_part >> 31) & 1'b1;

    if (sign) begin
        integer_part    = -integer_part;
        fractional_part = -fractional_part;
    end

    // $display("integer part: %d", integer_part);
    // $display("decimal part: %f", fractional_part);

    while(integer_part > 0) begin
        tmp_mantissa[i] = integer_part & 1'b1;
        integer_part >>= 1; 
        // $display("integer: %d index: %d", integer_part, i);
        // $display("%d", tmp_mantissa[i]);
        i++;
    end


    exp_bias    = i-1;
    exp_int     = 15+exp_bias;

    for(j=0; j<exp_bias; j++) begin
        mantissa[j] = tmp_mantissa[exp_bias-1-j];
        // $display("mantissa[%d]: %d", j, mantissa[j]);
    end

    while (fractional_part != 0.0 && j < 11) begin
        // $display("fractional:%f", fractional_part);

        fractional_part *= 2;

        // $display("frac after mul: %f", fractional_part);

        if (fractional_part > 0.99 && fractional_part < 1)
            fractional_part = 1;
        // $display("index: %d, fractional part: %f ", j, fractional_part);
        if (fractional_part >= 1)
            mantissa[j] = 1'b1;
        else
            mantissa[j] = 1'b0;
        // $display("mantissa[%d]: %d", j, mantissa[j]);
        j++;

        if (fractional_part >= 1 ) //begin
            // tmp_int = int'(fractional_part);
            // fractional_part = fractional_part - shortreal'(tmp_int);
            fractional_part -= 1;
        // end
        //  $display("frac after conversion: %f and tmp_int %d", fractional_part, tmp_int);
    end


    $display("mantissa %11b", mantissa);

    i = 0;

    while(exp_int > 0) begin
        exp_bin[i] = exp_int & 1'b1;
        exp_int >>= 1; 
        $display("integer: %d index: %d", exp_int, i);
        $display("%d", exp_bin[i]);
        i++;
    end
    
    ieee754[15] = sign;

     for (i = 0; i < 5; i++) begin
        ieee754[14 - i] = exp_bin[5 - 1 - i];
        //$display("ind:%d , exp: %d", i, exp_bin[5 - 1 - i]);
     end

        for (i = 0; i < 10; i++) begin
        ieee754[9 - i] = mantissa[i];
        end

        $display("ieee754: %16b", ieee754);

  end

    
endmodule