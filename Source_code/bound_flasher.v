module bound_flasher(
    input wire rst,
    input wire clk,
    input wire flick,
    output reg [15:0] LEDs
);
    reg [2:0] next_state;
    reg [2:0] current_state;
    reg [15:0] LEDsTemp;

    parameter   INIT            =  3'b000,
			    ON_0_TO_5 	    =  3'b001,
			    OFF_5_TO_0  	=  3'b010,
			    ON_0_TO_10  	=  3'b011,
			    OFF_10_TO_5  	=  3'b100,
			    ON_5_TO_15 	    =  3'b101,
                OFF_15_TO_0     =  3'b110,
                BLINK           =  3'b111;

// CLK    
    always @(posedge clk or negedge rst) begin
        if (rst == 1'b0) begin
            current_state <= INIT;
            LEDs <= 16'b0;
        end
        else begin
            current_state <= next_state;
            LEDs <= LEDsTemp;
        end
    end

// Logic
    always @(next_state or LEDs) begin
        case (next_state)
            INIT: begin
                LEDsTemp = 16'b0;
            end
            ON_0_TO_5: begin
                LEDsTemp = (LEDs << 1) | 1;
            end
            OFF_5_TO_0: begin
                LEDsTemp = LEDs >> 1;
            end
            ON_0_TO_10: begin
                LEDsTemp = (LEDs << 1) | 1;
            end
            OFF_10_TO_5: begin
                LEDsTemp = LEDs >> 1;
            end
            ON_5_TO_15: begin
                LEDsTemp = (LEDs << 1) | 1;
            end
            OFF_15_TO_0: begin
                LEDsTemp = LEDs >> 1;
            end
            BLINK: begin
                LEDsTemp = 16'b1111111111111111;
            end
            default: LEDsTemp = 16'b0;
        endcase
    end
    
    
// state   
    always @(flick or current_state or LEDs or rst) begin
        if (rst == 1'b0) begin
            next_state = INIT;
        end
        else begin
            case (current_state)
                INIT: begin
                    next_state = (flick == 1) ? ON_0_TO_5 : INIT;
                end
                ON_0_TO_5: begin
                    next_state = (LEDs[5] == 1) ? OFF_5_TO_0 : ON_0_TO_5;
                end
                OFF_5_TO_0: begin
                    next_state = (LEDs[0] == 0) ? ON_0_TO_10 : OFF_5_TO_0;
                end
                ON_0_TO_10: begin
                    if (flick == 1 && LEDs[10] == 1) begin
                        next_state = OFF_5_TO_0;
                    end
                    else if (flick == 1 && LEDs[5] == 1 && LEDs[6] == 0) begin
                        next_state = OFF_5_TO_0;
                    end 
                    else if (flick == 0 && LEDs[10] == 1) begin
                        next_state = OFF_10_TO_5;
                    end 
                end
                OFF_10_TO_5: begin	
                    next_state = (LEDs[5] == 0) ? ON_5_TO_15 : OFF_10_TO_5;
                end
                ON_5_TO_15: begin
                    if (flick == 1 && LEDs[5] == 1 && LEDs[6] == 0) begin
                        next_state = OFF_10_TO_5;
                    end
                    else if (flick == 1 && LEDs[10] == 1 && LEDs[11] == 0) begin
                        next_state = OFF_10_TO_5;
                    end
                    else if (LEDs[15] == 1) begin
                        next_state = OFF_15_TO_0;
                    end 
                end
                OFF_15_TO_0: begin
                    next_state = (LEDs[0] == 0) ? BLINK : OFF_15_TO_0;
                end
                BLINK:
                    next_state = INIT;
                default: next_state = INIT;
            endcase
        end
    end

endmodule
