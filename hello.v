module main (output reg [15:0] addr,
             output rw,
             output reg [15:0] d,
             input clk,
             input rst,
             output reg [15:0] pc,
             output reg [3:0] state,
             output reg [15:0] inst_0,
             output reg [15:0] inst_1,
             output reg [15:0] inst_2,
             output reg [15:0] inst_3,
             output reg [15:0] A,
             output reg [15:0] B,
             output reg [15:0] X,
             output reg [15:0] Y,
             output reg [15:0] Z,
             output reg [15:0] F,
             output reg [15:0] H,
             output reg [15:0] C,
             
             output reg [7:0] sp,
             
             output reg [15:0] out,
             output reg [15:0] tmp0,
             output reg [15:0] tmp1,
             output reg [7:0] regs,
             output reg [7:0] addrmod,
             output reg isout,
             
             output reg [15:0] chipio_data,
             output reg [15:0] chipio_port,
             output reg chipio_en,
             output reg chipio_rw,
            );
    always @ (posedge clk) begin
      
      if(rst) begin
        pc <= 1'b0;
      	state <= 1'b0;
        sp <= 255;
        
        A <= 0;
        B <= 0;
        X <= 0;
        Y <= 0;
        Z <= 0;
        F <= 0;
        H <= 0;
        C <= 0;
        end else begin
          if(state < 8) begin
      	  addr <= pc + 1;
          pc <= addr;
            if(state == 1)
              inst_0 <= d;
            else if(state == 3)
              inst_1 <= d;
            else if(state == 5)
              inst_2 <= d;
            else if(state == 7)
              inst_3 <= d;
            
          end else if(state == 8) begin
            
            regs <= inst_1 & 255;
            addrmod <= (inst_1 & 65280) >> 8;
            
            
            if(regs & 8 == 0)
              tmp0 <= A;
            if(regs & 8 == 1)
              tmp0 <= B;
            if(regs & 8 == 2)
              tmp0 <= X;
            if(regs & 8 == 3)
              tmp0 <= Y;
            if(regs & 8 == 4)
              tmp0 <= Z;
            if(regs & 8 == 5)
              tmp0 <= F;
            if(regs & 8 == 6)
              tmp0 <= H;
            if(regs & 8 == 7)
              tmp0 <= pc;
            if(regs & 8 == 8)
              tmp0 <= inst_2;
            if(regs & 8 == 9)
              tmp0 <= C;
            if(regs & 8 == 10) begin
              addr <= A;
              rw <= 1;
              tmp0 <= d;
            end
            if(regs & 8 == 11) begin
              addr <= B;
              rw <= 1;
              tmp0 <= d;
            end
            if(regs & 8 == 12) begin
              addr <= Z;
              rw <= 1;
              tmp0 <= d;
            end
            if(regs & 8 == 13) begin
              addr <= H;
              rw <= 1;
              tmp0 <= d;
            end
            if(regs & 8 == 14) begin
              addr <= inst_2;
              rw <= 1;
              tmp0 <= d;
            end
            if(regs & 8 == 15) begin
              addr <= C;
              rw <= 1;
              tmp0 <= d;
            end
            
            
            if((regs & 240) >> 4 == 0)
              tmp1 <= A;
            if((regs & 240) >> 4 == 1)
              tmp1 <= B;
            if((regs & 240) >> 4 == 2)
              tmp1 <= X;
            if((regs & 240) >> 4 == 3)
              tmp1 <= Y;
            if((regs & 240) >> 4 == 4)
              tmp1 <= Z;
            if((regs & 240) >> 4 == 5)
              tmp1 <= F;
            if((regs & 240) >> 4 == 6)
              tmp1 <= H;
            if((regs & 240) >> 4 == 7)
              tmp1 <= pc;
            if((regs & 240) >> 4 == 8)
              tmp1 <= inst_3;
            if((regs & 240) >> 4 == 9)
              tmp1 <= C;
            if((regs & 240) >> 4 == 10) begin
              addr <= A;
              rw <= 1;
              tmp1 <= d;
            end
            if((regs & 240) >> 4 == 11) begin
              addr <= B;
              rw <= 1;
              tmp1 <= d;
            end
            if((regs & 240) >> 4 == 12) begin
              addr <= Z;
              rw <= 1;
              tmp1 <= d;
            end
            if((regs & 240) >> 4 == 13) begin
              addr <= H;
              rw <= 1;
              tmp1 <= d;
            end
            if((regs & 240) >> 4 == 14) begin
              addr <= inst_3;
              rw <= 1;
              tmp1 <= d;
            end
            if((regs & 240) >> 4 == 15) begin
              addr <= C;
              rw <= 1;
              tmp1 <= d;
            end
            
            if(addrmod == 1)
              tmp1 <= tmp1 + X;
            if(addrmod == 2)
              tmp1 <= tmp1 + Y;
            if(addrmod == 3)
              tmp1 <= tmp1 + X;
              tmp0 <= tmp0 + Y;
            if(addrmod == 4)
              tmp1 <= tmp1 + Y;
              tmp0 <= tmp0 + X;
            out <= 0;
            isout <= 0;
            chipio_en <= 0;
            //decode and execute
            if(inst_0 == 1) begin
            	out <= tmp0 + tmp1;
              	isout <= 1;
            end
            if(inst_0 == 2) begin
            	out <= tmp0 - tmp1;
              	isout <= 1;
            end
            if(inst_0 == 3) begin
            	out <= tmp0 * tmp1;
              	isout <= 1;
            end
            if(inst_0 == 4) begin
            	out <= tmp0 / tmp1;
              	isout <= 1;
            end
            if(inst_0 == 5) begin
              if(tmp0 > tmp1)
                out <= 65535;
              else if(tmp0 == tmp1)
                out <= 0;
              else
                out <= 1;
              	isout <= 1;
            end
            if(inst_0 == 6) begin
              pc <= tmp1;
            end
            if(inst_0 == 8)begin
              out <= tmp0 & tmp1;
              isout <= 1;
            end
            if(inst_0 == 9)begin
              out <= !tmp0;
              isout <= 1;
            end
            if(inst_0 == 10)begin
              out <= tmp0 | tmp1;
              isout <= 1;
            end
            if(inst_0 == 11)begin
              out <= tmp0 ^ tmp1;
              isout <= 1;
            end
            if(inst_0 == 12)begin
              chipio_rw <= 1;
              chipio_port <= tmp0;
              chipio_data <= xxxxxxxxxxxxxxx;
              chipio_en <= 1;
              out <= chipio_data;
              isout <= 1;
            end
            if(inst_0 == 13)begin
              chipio_rw <= 0;
              chipio_port <= tmp0;
              chipio_data <= tmp1;
              chipio_en <= 1;
            end
            if(inst_0 == 14)begin
              out <= tmp1 >> tmp0;
              isout <= 1;
            end
            if(inst_0 == 15)begin
              out <= tmp1 << tmp0;
              isout <= 1;
            end
            if(inst_0 == 16)begin //set
              addr <= tmp0;
              d <= tmp1;
              rw <= 0;
            end
            if(inst_0 == 17)begin //get
              addr <= tmp0;
              out <= d;
              rw <= 1;
              isout <= 1;
            end
            if(inst_0 == 18)begin
              if(tmp0 == 0)
                pc <= tmp1;
            end
            if(inst_0 == 19)begin
              out <= $urandom;
              isout <= 1;
            end
            if(inst_0 == 20)begin
              out <= tmp0;
              isout <= 1;
            end
            if(inst_0 == 21)begin //psh
              addr <= (255 << 8) | sp;
              d <= tmp1;
              rw <= 0;
              sp <= sp - 1;
            end
            if(inst_0 == 22)begin //pop
              sp <= sp + 1;
              addr <= (255 << 8) | sp;
              rw <= 1;
              out <= d;
              isout <= 1;
            end
            if(inst_0 == 23)begin
              out <= tmp0 % tmp1;
              isout <= 1;
            end
            if(inst_0 == 24)begin //hlt
              
            end
            if(inst_0 == 25)begin
              if(tmp0 != 0)
                pc <= tmp1;
            end
            if(inst_0 == 26)begin
              out <= tmp0 ** tmp1;
              	isout <= 1;
            end
            if(inst_0 == 27)begin //cal
              addr <= (255 << 8) | sp;
              d <= pc;
              rw <= 0;
              sp <= sp - 1;
              pc <= tmp1;
            end
            if(inst_0 == 28)begin //ret
              sp <= sp + 1;
              addr <= (255 << 8) | sp;
              rw <= 1;
              pc <= d;
            end
            
            
            
            
            if((regs & 240) >> 4 == 0)
              A <= out;
            if((regs & 240) >> 4 == 1)
              B <= out;
            if((regs & 240) >> 4 == 2)
              X <= out;
            if((regs & 240) >> 4 == 3)
              Y <= out;
            if((regs & 240) >> 4 == 4)
              Z <= out;
            if((regs & 240) >> 4 == 5)
              F <= out;
            if((regs & 240) >> 4 == 6)
              H <= out;
            if((regs & 240) >> 4 == 7)
              pc <= out;
            if((regs & 240) >> 4 == 9)
              C <= out;
            if((regs & 240) >> 4 == 10) begin
              addr <= A;
              rw <= 0;
              d <= A;
            end
            if((regs & 240) >> 4 == 11) begin
              addr <= B;
              rw <= 0;
              d <= B;
            end
            if((regs & 240) >> 4 == 12) begin
              addr <= Z;
              rw <= 0;
              d <= Z;
            end
            if((regs & 240) >> 4 == 13) begin
              addr <= H;
              rw <= 0;
              d <= H;
            end
            if((regs & 240) >> 4 == 14) begin
              addr <= inst_3;
              rw <= 0;
              d <= inst_3;
            end
            if((regs & 240) >> 4 == 15) begin
              addr <= C;
              rw <= 0;
              d <= C;
            end
            
            
          end
      	state <= state + 1;
          if(state == 10)
            state <= 0;
        end
    end

endmodule