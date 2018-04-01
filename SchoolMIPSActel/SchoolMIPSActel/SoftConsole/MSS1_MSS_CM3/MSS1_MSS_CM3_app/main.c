#include "drivers/mss_timer/mss_timer.h"
#include "drivers/mss_gpio/mss_gpio.h"
#include "drivers/mss_uart/mss_uart.h"
#include "drivers/mss_spi/mss_spi.h"
#include "drivers/mss_timer/mss_timer.h"
#include "drivers_config/sys_config/sys_config.h"
#include "CMSIS/system_m2sxxx.h"

//MIPS rst_n input
#define rst_n MSS_GPIO_10
//MIPS clk input
#define cpu_clk MSS_GPIO_14
//TDO
#define TDO MSS_GPIO_15
//TRST
#define TRST MSS_GPIO_16
//TDI
#define TDI MSS_GPIO_13
//TCK
#define TCK MSS_GPIO_12

//Test TMS select input
#define TMS MSS_GPIO_11
//MUX MIPS select inputs
#define sel_MUX1 MSS_GPIO_9
#define sel_MUX0 MSS_GPIO_8
//MUX MIPS data outputs
#define reg_MUX7 MSS_GPIO_7
#define reg_MUX6 MSS_GPIO_6
#define reg_MUX5 MSS_GPIO_5
#define reg_MUX4 MSS_GPIO_4
#define reg_MUX3 MSS_GPIO_3
#define reg_MUX2 MSS_GPIO_2
#define reg_MUX1 MSS_GPIO_1
#define reg_MUX0 MSS_GPIO_0

#define s_TMS	MSS_GPIO_set_output(TMS,1);
#define c_TMS	MSS_GPIO_set_output(TMS,0);
#define s_TDI	MSS_GPIO_set_output(TDI,1);
#define c_TDI	MSS_GPIO_set_output(TDI,0);
#define o_TDO	((MSS_GPIO_get_inputs()>>15)&0x01)
#define clock	MSS_GPIO_set_output(TCK,1); 	MSS_GPIO_set_output(TCK,0);
#define clock_cpu	MSS_GPIO_set_output(cpu_clk,1); 	MSS_GPIO_set_output(cpu_clk,0);

void uart0_rx_handler(mss_uart_instance_t * this_uart);

mss_uart_instance_t * const gp_my_uart = &g_mss_uart0;
uint8_t commandBuf[20];
uint8_t commandNumber=0;
uint8_t commandReady=0;

uint8_t number=0;
uint8_t serialData[5]={0x02,0x02,0x02,0x02,0x02};

uint32_t GPIO_Value=0;
uint8_t GPIO_Buff[4];
uint8_t Message[10]="HelloWorld";

void show_reg(uint8_t addr)
{
	/*MSS_GPIO_set_output(update_dr,0);
	// Enable parallel storage data_register
	MSS_GPIO_set_output(shift_dr,0);
	// Maybe this line is not needed
	MSS_SPI_set_slave_select( &g_mss_spi0, MSS_SPI_SLAVE_0 );
	// Update parallel data_register
	MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );
	// Enable serial storage data_register
	MSS_GPIO_set_output(shift_dr,1);
	// Enable 0x02 MIPS register
	serialData[0]=addr;
	// Load and storage serial data
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );
	// Update address
	MSS_GPIO_set_output(update_dr,1);
	MSS_GPIO_set_output(update_dr,0);
	// Enable parallel storage data_register
	MSS_GPIO_set_output(shift_dr,0);
	// Update parallel data_register
	MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );
	// Enable serial storage data_register
	MSS_GPIO_set_output(shift_dr,1);
	// Load and storage serial data
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );
	serialData[1]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[1] );
	serialData[2]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[2] );
	serialData[3]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[3] );
	serialData[4]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[4] );
	// Maybe this line is not needed
	MSS_SPI_clear_slave_select( &g_mss_spi0, MSS_SPI_SLAVE_0 );
	// Enable parallel storage data_register
	MSS_GPIO_set_output(shift_dr,0);
	// Message generation*/
	int i=0;
	for (i=3;i>=0;i--)
		switch (serialData[i]&0x0F)
		{
			case 0x00:
				Message[i*2+1]='0';
			break;
			case 0x01:
				Message[i*2+1]='1';
			break;
			case 0x02:
				Message[i*2+1]='2';
			break;
			case 0x03:
				Message[i*2+1]='3';
			break;
			case 0x04:
				Message[i*2+1]='4';
			break;
			case 0x05:
				Message[i*2+1]='5';
			break;
			case 0x06:
				Message[i*2+1]='6';
			break;
			case 0x07:
				Message[i*2+1]='7';
			break;
			case 0x08:
				Message[i*2+1]='8';
			break;
			case 0x09:
				Message[i*2+1]='9';
			break;
			case 0x0a:
				Message[i*2+1]='A';
			break;
			case 0x0b:
				Message[i*2+1]='B';
			break;
			case 0x0c:
				Message[i*2+1]='C';
			break;
			case 0x0d:
				Message[i*2+1]='D';
			break;
			case 0x0e:
				Message[i*2+1]='E';
			break;
			case 0x0f:
				Message[i*2+1]='F';
			break;
			}
	for (i=3;i>=0;i--)
		switch (serialData[i]&0xF0)
			{
			case 0x00:
				Message[i*2]='0';
			break;
			case 0x10:
				Message[i*2]='1';
			break;
			case 0x20:
				Message[i*2]='2';
			break;
			case 0x30:
				Message[i*2]='3';
			break;
			case 0x40:
				Message[i*2]='4';
			break;
			case 0x50:
				Message[i*2]='5';
			break;
			case 0x60:
				Message[i*2]='6';
			break;
			case 0x70:
				Message[i*2]='7';
			break;
			case 0x80:
				Message[i*2]='8';
			break;
			case 0x90:
				Message[i*2]='9';
			break;
			case 0xa0:
				Message[i*2]='A';
			break;
			case 0xb0:
				Message[i*2]='B';
			break;
			case 0xc0:
				Message[i*2]='C';
			break;
			case 0xd0:
				Message[i*2]='D';
			break;
			case 0xe0:
				Message[i*2]='E';
			break;
			case 0xf0:
				Message[i*2]='F';
			break;
			}
	Message[8]='\r';
	Message[9]='\n';
	//Sending message
	MSS_UART_polled_tx_string(gp_my_uart, Message);
}

uint32_t timervalue=1563;

void one_clock()
{
	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
}
void write(uint8_t addr)
{
	c_TMS;
	if(((addr>>7)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	clock;
	if(((addr>>6)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	if(((addr>>5)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	if(((addr>>4)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	if(((addr>>3)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	if(((addr>>2)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	if(((addr>>1)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
	//s_TMS;
	if(((addr>>0)&0x01)==0x00)
			c_TDI
		else
			s_TDI
	clock;
}

uint8_t read()
{
	c_TMS;
	uint8_t data=0x00;
	data=data | (o_TDO<<7);
	clock;
	data=data | (o_TDO<<6);
	clock;
	data=data | (o_TDO<<5);
	clock;
	data=data | (o_TDO<<4);
	clock;
	data=data | (o_TDO<<3);
	clock;
	data=data | (o_TDO<<2);
	clock;
	data=data | (o_TDO<<1);
	clock;
	data=data | (o_TDO<<0);
	clock;
	return data;
}

uint8_t read_write(uint8_t addr, uint8_t complete)
{
	c_TMS;
	uint8_t data=0x00;
	if(((addr>>7)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<7);
	clock;
	if(((addr>>6)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<6);
	clock;
	if(((addr>>5)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<5);
	clock;
	if(((addr>>4)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<4);
	clock;
	if(((addr>>3)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<3);
	clock;
	if(((addr>>2)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<2);
	clock;
	if(((addr>>1)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<1);
	clock;
	if(((addr>>0)&0x01)==0x00)
		c_TDI
	else
		s_TDI
	data=data | (o_TDO<<0);
	if (complete!=0x00)
		s_TMS
	else
		c_TMS
	clock;
	return data;
}
void print_reg(uint8_t *data)
{
	int i=0;
	for (i=3;i>=0;i--)
		switch (data[i]&0x0F)
		{
			case 0x00:
				Message[i*2+1]='0';
			break;
			case 0x01:
				Message[i*2+1]='1';
			break;
			case 0x02:
				Message[i*2+1]='2';
			break;
			case 0x03:
				Message[i*2+1]='3';
			break;
			case 0x04:
				Message[i*2+1]='4';
			break;
			case 0x05:
				Message[i*2+1]='5';
			break;
			case 0x06:
				Message[i*2+1]='6';
			break;
			case 0x07:
				Message[i*2+1]='7';
			break;
			case 0x08:
				Message[i*2+1]='8';
			break;
			case 0x09:
				Message[i*2+1]='9';
			break;
			case 0x0a:
				Message[i*2+1]='A';
			break;
			case 0x0b:
				Message[i*2+1]='B';
			break;
			case 0x0c:
				Message[i*2+1]='C';
			break;
			case 0x0d:
				Message[i*2+1]='D';
			break;
			case 0x0e:
				Message[i*2+1]='E';
			break;
			case 0x0f:
				Message[i*2+1]='F';
			break;
			}
	for (i=3;i>=0;i--)
		switch (data[i]&0xF0)
			{
			case 0x00:
				Message[i*2]='0';
			break;
			case 0x10:
				Message[i*2]='1';
			break;
			case 0x20:
				Message[i*2]='2';
			break;
			case 0x30:
				Message[i*2]='3';
			break;
			case 0x40:
				Message[i*2]='4';
			break;
			case 0x50:
				Message[i*2]='5';
			break;
			case 0x60:
				Message[i*2]='6';
			break;
			case 0x70:
				Message[i*2]='7';
			break;
			case 0x80:
				Message[i*2]='8';
			break;
			case 0x90:
				Message[i*2]='9';
			break;
			case 0xa0:
				Message[i*2]='A';
			break;
			case 0xb0:
				Message[i*2]='B';
			break;
			case 0xc0:
				Message[i*2]='C';
			break;
			case 0xd0:
				Message[i*2]='D';
			break;
			case 0xe0:
				Message[i*2]='E';
			break;
			case 0xf0:
				Message[i*2]='F';
			break;
			}
	Message[8]='\r';
	Message[9]='\n';
	//Sending message
	MSS_UART_polled_tx_string(gp_my_uart, Message);
}

uint8_t eiths_clock(uint8_t in)
{
	uint8_t data=0;
	uint32_t gpio_inputs;
	MSS_GPIO_set_output(TDI,in);
	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x01&(gpio_inputs>>15));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x02&(gpio_inputs>>14));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x04&(gpio_inputs>>13));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x08&(gpio_inputs>>12));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x10&(gpio_inputs>>11));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x20&(gpio_inputs>>10));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x40&(gpio_inputs>>9));

	MSS_GPIO_set_output(TCK,1);
	MSS_GPIO_set_output(TCK,0);
	gpio_inputs=MSS_GPIO_get_inputs();
	data=data|(0x80&(gpio_inputs>>8));

	return data;
}

void one_reg(uint8_t addr)
{
	MSS_GPIO_set_output(TMS,1);
	//serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SELECT_DR_SCAN
	//eiths_clock();//go to SELECT_DR_SCAN
	MSS_GPIO_set_output(TMS,0);
	//serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to CAPTURE_DR
	//eiths_clock();//go to CAPTURE_DR
	MSS_GPIO_set_output(TMS,0);
	//serialData[0]=addr;
	one_clock();
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
	serialData[0]=addr;
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
	MSS_GPIO_set_output(TMS,1);
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to EXIT1_DR
	MSS_GPIO_set_output(TMS,1);
	serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to UPDATE_DR

	MSS_GPIO_set_output(TMS,1);
		serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SELECT_DR_SCAN
		MSS_GPIO_set_output(TMS,0);
		serialData[0]=0x00;
		serialData[1]=0x00;
		serialData[2]=0x00;
		serialData[3]=0x00;
		serialData[4]=0x00;
		serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
		serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
		serialData[1]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
		serialData[2]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
		serialData[3]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR
		serialData[4]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to SHIFT_DR

		MSS_GPIO_set_output(TMS,1);
		serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to EXIT1_DR
		MSS_GPIO_set_output(TMS,0);
		serialData[0]=MSS_SPI_transfer_frame( &g_mss_spi0, serialData[0] );	//go to UPDATE_DR

		MSS_GPIO_set_output(cpu_clk,1);
		MSS_GPIO_set_output(cpu_clk,0);
}
void read_one_reg(uint8_t addr, uint8_t *data)
{
	c_TMS;
	clock;
	clock;
	read_write(addr,0x01);
	clock;
	clock;
	c_TMS
	clock;
	clock;
	//clock;
	data[0]= read_write(0x00,0x00);
	data[1]= read_write(0x00,0x00);
	data[2]= read_write(0x00,0x00);
	data[3]= read_write(0x00,0x01);
	clock;
	clock;
	c_TMS
	clock;
	clock;
}

int main()
{
    MSS_UART_init(gp_my_uart, MSS_UART_115200_BAUD,
                  MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);
    /*MSS_UART_set_rx_handler(gp_my_uart, uart0_rx_handler,
                              MSS_UART_FIFO_SINGLE_BYTE);*/

    MSS_GPIO_init();
    //reg_MUX inputs. MIPS reg outputs [7:0] or [15:8] or [23:9] or [31:24]
    MSS_GPIO_config(reg_MUX0 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX1 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX2 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX3 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX4 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX5 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX6 , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(reg_MUX7 , MSS_GPIO_INPUT_MODE );
    //MUX sel inputs. Enable MIPS reg outputs [7:0] or [15:8] or [23:9] or [31:24]
    MSS_GPIO_config(sel_MUX0 , MSS_GPIO_OUTPUT_MODE );
    MSS_GPIO_config(sel_MUX1 , MSS_GPIO_OUTPUT_MODE );
    //Configuring MIPS inputs to test
    MSS_GPIO_config(cpu_clk , MSS_GPIO_OUTPUT_MODE );
    MSS_GPIO_config(TMS , MSS_GPIO_OUTPUT_MODE );
    MSS_GPIO_config(TDI , MSS_GPIO_OUTPUT_MODE );
    MSS_GPIO_config(TCK , MSS_GPIO_OUTPUT_MODE );
    MSS_GPIO_config(TDO , MSS_GPIO_INPUT_MODE );
    MSS_GPIO_config(TRST , MSS_GPIO_OUTPUT_MODE );

    //MIPS rst_n input
    MSS_GPIO_config(rst_n , MSS_GPIO_OUTPUT_MODE );
    //Reset MIPS
    MSS_GPIO_set_output(rst_n,0);
    MSS_GPIO_set_output(cpu_clk,1);
    MSS_GPIO_set_output(cpu_clk,0);
    MSS_GPIO_set_output(cpu_clk,1);
    MSS_GPIO_set_output(cpu_clk,0);
    MSS_GPIO_set_output(cpu_clk,1);
    MSS_GPIO_set_output(cpu_clk,0);
    MSS_GPIO_set_output(rst_n,1);
    MSS_SPI_init(&g_mss_spi0);
    MSS_SPI_configure_master_mode(&g_mss_spi0,MSS_SPI_SLAVE_0,MSS_SPI_MODE0,16u,8);
    MSS_GPIO_set_output(TMS,1);
    MSS_GPIO_set_output(TRST,0);
    int i;
    MSS_GPIO_set_output(TRST,1);
    c_TMS;
    clock;
    clock;
    s_TMS;
    clock;
    clock;
    c_TMS;
    clock;
    clock;
    clock;

    /*BYPASS={width{1'b1}},
                SAMPLE_PRELOAD={{(width-1){1'b0}},1'b1},
                IDCODE={width{1'b0}},*/
    serialData[0]=read_write(0x01,0x00);
    serialData[0]=read_write(0x01,0x01);
    clock;
    clock;
    c_TMS
    clock;
    clock;

    uint8_t reg_data[4];
    while (1)
    {
    	for(i=0;i<32;i++)
    	        		{
    	        			uint8_t name[7];
    	        			if(i==0)
    	        			{
    	        				name[0]='p';
    	        				name[1]='c';
    	        				name[2]='=';
    	        				name[3]='\0';
    	        				MSS_UART_polled_tx_string(gp_my_uart, name);
    	        			}
    	        			if(i==1)
    	        			    {
    	        			        name[0]='a';
    	        			        name[1]='t';
    	        			        name[2]='=';
    	        			        name[3]='\0';
    	        			        MSS_UART_polled_tx_string(gp_my_uart, name);
    	        			    }
    	        			if(i==2)
    	        			    {
    	        			        name[0]='v';
    	        			        name[1]='0';
    	        			        name[2]='=';
    	        			        name[3]='\0';
    	        			        MSS_UART_polled_tx_string(gp_my_uart, name);
    	        			    }
    	        		    if(i==3)
    	        			    {
    	        			        name[0]='v';
    	        			        name[1]='1';
    	        			        name[2]='=';
    	        			        name[3]='\0';
    	        			        MSS_UART_polled_tx_string(gp_my_uart, name);
    	        			    }
    	        			if(i==4)
    							{
    								name[0]='a';
    								name[1]='0';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==5)
    							{
    								name[0]='a';
    								name[1]='1';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==6)
    							{
    								name[0]='a';
    								name[1]='2';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==7)
    							{
    								name[0]='a';
    								name[1]='3';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==8)
    							{
    								name[0]='t';
    								name[1]='0';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==9)
    							{
    								name[0]='t';
    								name[1]='1';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==10)
    							{
    								name[0]='t';
    								name[1]='2';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==11)
    							{
    								name[0]='t';
    								name[1]='3';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==12)
    							{
    								name[0]='t';
    								name[1]='4';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==13)
    							{
    								name[0]='t';
    								name[1]='5';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==14)
    							{
    								name[0]='t';
    								name[1]='6';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==15)
    							{
    								name[0]='t';
    								name[1]='7';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==16)
    							{
    								name[0]='s';
    								name[1]='0';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==17)
    							{
    								name[0]='s';
    								name[1]='1';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==18)
    							{
    								name[0]='s';
    								name[1]='2';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==19)
    							{
    								name[0]='s';
    								name[1]='3';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==20)
    							{
    								name[0]='s';
    								name[1]='4';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==21)
    							{
    								name[0]='s';
    								name[1]='5';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==22)
    							{
    								name[0]='s';
    								name[1]='6';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==23)
    							{
    								name[0]='s';
    								name[1]='7';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==24)
    							{
    								name[0]='t';
    								name[1]='8';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==25)
    							{
    								name[0]='t';
    								name[1]='9';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==26)
    							{
    								name[0]='k';
    								name[1]='0';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==27)
    							{
    								name[0]='k';
    								name[1]='1';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==28)
    							{
    								name[0]='g';
    								name[1]='p';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==29)
    							{
    								name[0]='s';
    								name[1]='p';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==30)
    							{
    								name[0]='f';
    								name[1]='p';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			if(i==31)
    							{
    								name[0]='r';
    								name[1]='a';
    								name[2]='=';
    								name[3]='\0';
    								MSS_UART_polled_tx_string(gp_my_uart, name);
    							}
    	        			read_one_reg(i,reg_data);
    	        			print_reg(reg_data);
    	        			//show_reg(i);
    	        		}
    	//read_one_reg(0x02, reg_data);
    	//show_reg(reg_data);
    	clock_cpu;
    }
    /*
    c_TMS;
    clock;
    clock;
    serialData[0]=0x00;
    serialData[0]= read_write(0x00,0x01);
    clock;
    clock;
    c_TMS
    clock;
    clock;
    while(1)
    {
    serialData[0]= read_write(0x02,0x00);
    serialData[1]= read_write(0x02,0x00);
    serialData[2]= read_write(0x02,0x00);
    serialData[3]= read_write(0x02,0x00);
    serialData[4]= read_write(0x02,0x01);
    clock_cpu
    clock;
    clock;
    c_TMS
    clock;
    clock;
    //clock_cpu
    }*/




    for(;;)
    {
    	//one_reg(0x00);
        if(commandReady==1)
        {
        	uint8_t newBuf[3]="\r\n\0";
        	MSS_UART_polled_tx_string(gp_my_uart, newBuf);
        	if((commandBuf[0]=='c')&&(commandBuf[1]=='l')&&(commandBuf[2]=='o')&&(commandBuf[3]=='c')&&(commandBuf[4]=='k'))
        	{
        	    MSS_GPIO_set_output(cpu_clk,1);
        	    MSS_GPIO_set_output(cpu_clk,0);
        	}
        	if((commandBuf[0]=='r')&&(commandBuf[1]=='e')&&(commandBuf[2]=='g')&&(commandBuf[3]=='_')&&(commandBuf[4]=='a'))
        	{
        		for(i=0;i<32;i++)
        		{
        			uint8_t name[7];
        			if(i==0)
        			{
        				name[0]='p';
        				name[1]='c';
        				name[2]='=';
        				name[3]='\0';
        				MSS_UART_polled_tx_string(gp_my_uart, name);
        			}
        			if(i==1)
        			    {
        			        name[0]='a';
        			        name[1]='t';
        			        name[2]='=';
        			        name[3]='\0';
        			        MSS_UART_polled_tx_string(gp_my_uart, name);
        			    }
        			if(i==2)
        			    {
        			        name[0]='v';
        			        name[1]='0';
        			        name[2]='=';
        			        name[3]='\0';
        			        MSS_UART_polled_tx_string(gp_my_uart, name);
        			    }
        		    if(i==3)
        			    {
        			        name[0]='v';
        			        name[1]='1';
        			        name[2]='=';
        			        name[3]='\0';
        			        MSS_UART_polled_tx_string(gp_my_uart, name);
        			    }
        			if(i==4)
						{
							name[0]='a';
							name[1]='0';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==5)
						{
							name[0]='a';
							name[1]='1';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==6)
						{
							name[0]='a';
							name[1]='2';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==7)
						{
							name[0]='a';
							name[1]='3';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==8)
						{
							name[0]='t';
							name[1]='0';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==9)
						{
							name[0]='t';
							name[1]='1';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==10)
						{
							name[0]='t';
							name[1]='2';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==11)
						{
							name[0]='t';
							name[1]='3';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==12)
						{
							name[0]='t';
							name[1]='4';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==13)
						{
							name[0]='t';
							name[1]='5';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==14)
						{
							name[0]='t';
							name[1]='6';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==15)
						{
							name[0]='t';
							name[1]='7';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==16)
						{
							name[0]='s';
							name[1]='0';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==17)
						{
							name[0]='s';
							name[1]='1';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==18)
						{
							name[0]='s';
							name[1]='2';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==19)
						{
							name[0]='s';
							name[1]='3';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==20)
						{
							name[0]='s';
							name[1]='4';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==21)
						{
							name[0]='s';
							name[1]='5';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==22)
						{
							name[0]='s';
							name[1]='6';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==23)
						{
							name[0]='s';
							name[1]='7';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==24)
						{
							name[0]='t';
							name[1]='8';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==25)
						{
							name[0]='t';
							name[1]='9';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==26)
						{
							name[0]='k';
							name[1]='0';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==27)
						{
							name[0]='k';
							name[1]='1';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==28)
						{
							name[0]='g';
							name[1]='p';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==29)
						{
							name[0]='s';
							name[1]='p';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==30)
						{
							name[0]='f';
							name[1]='p';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			if(i==31)
						{
							name[0]='r';
							name[1]='a';
							name[2]='=';
							name[3]='\0';
							MSS_UART_polled_tx_string(gp_my_uart, name);
						}
        			show_reg(i);
        		}
        		//show_reg(((commandBuf[6]-0x30)&0xF0)|((commandBuf[7]-0x30)&0x0F));
        	}
        	if((commandBuf[0]=='r')&&(commandBuf[1]=='s')&&(commandBuf[2]=='t')&&(commandBuf[3]=='_')&&(commandBuf[4]=='n'))
        	{
        		MSS_GPIO_set_output(rst_n,0);
        		MSS_GPIO_set_output(cpu_clk,1);
        		MSS_GPIO_set_output(cpu_clk,0);
        		MSS_GPIO_set_output(cpu_clk,1);
        		MSS_GPIO_set_output(cpu_clk,0);
        		MSS_GPIO_set_output(cpu_clk,1);
        		MSS_GPIO_set_output(cpu_clk,0);
        		MSS_GPIO_set_output(rst_n,1);
        	}
        	commandReady=0;
        	commandNumber=0;


        	for (i=0;i<20;i++)
        		commandBuf[i]='\0';
        }
    }
}


void uart0_rx_handler(mss_uart_instance_t * this_uart)
{
	MSS_UART_get_rx(this_uart, &commandBuf[commandNumber], 1);
	if(commandReady==0)
	{		if(commandBuf[commandNumber]!=0x0D)
		{
			MSS_UART_polled_tx_string(gp_my_uart, &commandBuf[commandNumber]);
			commandNumber++;
			if(commandNumber==19)
				commandNumber=0;
		}
		else
		{
			commandReady=1;
		}
	}
}
