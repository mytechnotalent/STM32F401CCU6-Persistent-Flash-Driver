;------------------------------------------------------------------------------------------
; MIT License
;
; Copyright (c) 2023 My Techno Talent
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;
; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
; IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
; FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
; AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
; LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
; OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
; SOFTWARE.
;------------------------------------------------------------------------------------------
; FILE: main.s
;
; DESCRIPTION:
; This file contains the assembly code for a program that creates persistent storage
; using the onboard flash utilizing the STM32F401CC6 microcontroller.
; 
; AUTHOR: Kevin Thomas
; DATE CREATED: July 4, 2023
; DATE UPDATED: July 4, 2023
; 
; USAGE:
; 1. Assemble and link the code using the Keil.
; 2. Run or debug the binary using the Keil.
;------------------------------------------------------------------------------------------
Stack_Size      EQU     0x00000400

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp
                PRESERVE8
                THUMB

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors
                EXPORT  __Vectors_End
                EXPORT  __Vectors_Size

__Vectors       DCD     __initial_sp                      ; Top of Stack
                DCD     Reset_Handler                     ; Reset Handler
                DCD     NMI_Handler                       ; NMI Handler
                DCD     HardFault_Handler                 ; Hard Fault Handler
                DCD     MemManage_Handler                 ; MPU Fault Handler
                DCD     BusFault_Handler                  ; Bus Fault Handler
                DCD     UsageFault_Handler                ; Usage Fault Handler
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     SVC_Handler                       ; SVCall Handler
                DCD     DebugMon_Handler                  ; Debug Monitor Handler
                DCD     0                                 ; Reserved
                DCD     PendSV_Handler                    ; PendSV Handler
                DCD     SysTick_Handler                   ; SysTick Handler
                DCD     WWDG_IRQHandler                   ; Window WatchDog
                DCD     PVD_IRQHandler                    ; PVD through EXTI Line detection
                DCD     TAMP_STAMP_IRQHandler             ; Tamper and TimeStamps through the EXTI line
                DCD     RTC_WKUP_IRQHandler               ; RTC Wakeup through the EXTI line
                DCD     FLASH_IRQHandler                  ; FLASH
                DCD     RCC_IRQHandler                    ; RCC
                DCD     EXTI0_IRQHandler                  ; EXTI Line0
                DCD     EXTI1_IRQHandler                  ; EXTI Line1
                DCD     EXTI2_IRQHandler                  ; EXTI Line2
                DCD     EXTI3_IRQHandler                  ; EXTI Line3
                DCD     EXTI4_IRQHandler                  ; EXTI Line4
                DCD     DMA1_Stream0_IRQHandler           ; DMA1 Stream 0
                DCD     DMA1_Stream1_IRQHandler           ; DMA1 Stream 1
                DCD     DMA1_Stream2_IRQHandler           ; DMA1 Stream 2
                DCD     DMA1_Stream3_IRQHandler           ; DMA1 Stream 3
                DCD     DMA1_Stream4_IRQHandler           ; DMA1 Stream 4
                DCD     DMA1_Stream5_IRQHandler           ; DMA1 Stream 5
                DCD     DMA1_Stream6_IRQHandler           ; DMA1 Stream 6
                DCD     ADC_IRQHandler                    ; ADC1, ADC2 and ADC3s
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     EXTI9_5_IRQHandler                ; External Line[9:5]s
                DCD     TIM1_BRK_TIM9_IRQHandler          ; TIM1 Break and TIM9
                DCD     TIM1_UP_TIM10_IRQHandler          ; TIM1 Update and TIM10
                DCD     TIM1_TRG_COM_TIM11_IRQHandler     ; TIM1 Trigger and Commutation and TIM11
                DCD     TIM1_CC_IRQHandler                ; TIM1 Capture Compare
                DCD     TIM2_IRQHandler                   ; TIM2
                DCD     TIM3_IRQHandler                   ; TIM3
                DCD     TIM4_IRQHandler                   ; TIM4
                DCD     I2C1_EV_IRQHandler                ; I2C1 Event
                DCD     I2C1_ER_IRQHandler                ; I2C1 Error
                DCD     I2C2_EV_IRQHandler                ; I2C2 Event
                DCD     I2C2_ER_IRQHandler                ; I2C2 Error
                DCD     SPI1_IRQHandler                   ; SPI1
                DCD     SPI2_IRQHandler                   ; SPI2
                DCD     USART1_IRQHandler                 ; USART1
                DCD     USART2_IRQHandler                 ; USART2
                DCD     0                                 ; Reserved
                DCD     EXTI15_10_IRQHandler              ; External Line[15:10]s
                DCD     RTC_Alarm_IRQHandler              ; RTC Alarm (A and B) through EXTI Line
                DCD     OTG_FS_WKUP_IRQHandler            ; USB OTG FS Wakeup through EXTI line                        
                DCD     0                                 ; Reserved                  
                DCD     0                                 ; Reserved                 
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved                                   
                DCD     DMA1_Stream7_IRQHandler           ; DMA1 Stream7                                           
                DCD     0                                 ; Reserved                                             
                DCD     SDIO_IRQHandler                   ; SDIO                                            
                DCD     TIM5_IRQHandler                   ; TIM5                                            
                DCD     SPI3_IRQHandler                   ; SPI3                                            
                DCD     0                                 ; Reserved                                           
                DCD     0                                 ; Reserved                                           
                DCD     0                                 ; Reserved                   
                DCD     0                                 ; Reserved                   
                DCD     DMA2_Stream0_IRQHandler           ; DMA2 Stream 0                                   
                DCD     DMA2_Stream1_IRQHandler           ; DMA2 Stream 1                                   
                DCD     DMA2_Stream2_IRQHandler           ; DMA2 Stream 2                                   
                DCD     DMA2_Stream3_IRQHandler           ; DMA2 Stream 3                                   
                DCD     DMA2_Stream4_IRQHandler           ; DMA2 Stream 4
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     OTG_FS_IRQHandler                 ; USB OTG FS
                DCD     DMA2_Stream5_IRQHandler           ; DMA2 Stream 5
                DCD     DMA2_Stream6_IRQHandler           ; DMA2 Stream 6
                DCD     DMA2_Stream7_IRQHandler           ; DMA2 Stream 7
                DCD     USART6_IRQHandler                 ; USART6
                DCD     I2C3_EV_IRQHandler                ; I2C3 event
                DCD     I2C3_ER_IRQHandler                ; I2C3 error
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     FPU_IRQHandler                    ; FPU
                DCD     0                                 ; Reserved
                DCD     0                                 ; Reserved
                DCD     SPI4_IRQHandler                   ; SPI4
__Vectors_End

__Vectors_Size  EQU  __Vectors_End - __Vectors

                AREA    |.text|, CODE, READONLY

Reset_Handler   PROC
                EXPORT  Reset_Handler                     [WEAK]
                LDR     R0, =__start
                BX      R0
;------------------------------------------------------------------------------------------------------------
__start
                BL      Unlock_Flash                      ; call the Unlock_Flash function

                BL      Erase_Sector_5_Flash              ; call the Erase_Sector_5_Flash function

                BL      Verify_FLASH_SR_BSY_Bit_Cleared   ; call the Verify_FLASH_SR_BSY_Bit_Cleared function

                BL      Enable_Write_To_Flash             ; call the Enable_Write_To_Flash function

                LDR     R0, =0x0803FFFC                   ; address to write to within sector 5 flash
                LDR     R1, =0xDEADBEEF                   ; data to write into the sector 5 address
                BL      Write_To_Flash                    ; call the Write_To_Flash function

                BL      Verify_FLASH_SR_BSY_Bit_Cleared   ; call the Verify_FLASH_SR_BSY_Bit_Cleared function

                BL      Lock_Flash                        ; call the Lock_Flash function
                    
                BL      Infinite_Loop                     ; call the Infinite_Loop function
;------------------------------------------------------------------------------------------------------------
Unlock_Flash
                PUSH    {R1-R12, LR}                      ; save register state
                LDR     R0, =0x40023C04                   ; load address of the FLASH_KEYR register
                LDR     R1, =0x45670123                   ; load value inside FLASH_KEYR register
                LDR     R2, =0xCDEF89AB                   ; load value inside FLASH_KEYR register
                STR     R1, [R0]                          ; store the value into the FLASH_KEYR register
                STR     R2, [R0]                          ; store the value into the FLASH_KEYR register
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller

Erase_Sector_5_Flash
                PUSH    {R1-R12, LR}                      ; save register state
                LDR     R0, =0x40023C10                   ; load address of the FLASH_CR register
                LDR     R1, [R0]                          ; load value inside FLASH_CR register
                ORR     R1, #1<<16                        ; set the STRT bit
                ORR     R1, #1<<5                         ; set the SNB bit, sector 5
                ORR     R1, #1<<3                         ; set the SNB bit, sector 5
                ORR     R1, #1<<1                         ; set the SER bit
                STR     R1, [R0]                          ; store value into the FLASH_CR register
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller
 
Verify_FLASH_SR_BSY_Bit_Cleared
                PUSH    {R1-R12, LR}                      ; save register state
                LDR     R0, =0x40023C0C                   ; load address of the FLASH_SR register
                LDR     R1, [R0]                          ; load value inside FLASH_SR register
                TST     R1, #1<<16                        ; test the BSY bit
                BNE     Verify_FLASH_SR_BSY_Bit_Cleared   ; branch back if BSY bit is still 1
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller

Enable_Write_To_Flash
                PUSH    {R1-R12, LR}                      ; save register state
                LDR     R0, =0x40023C10                   ; load address of the FLASH_CR register
                LDR     R1, [R0]                          ; load value inside FLASH_CR register
                ORR     R1, #1<<0                         ; set the PG bit
                ORR     R1, #1<<9                         ; set the PSIZE bit, program x32
                AND     R1, #~(0<<8)                      ; clear the PSIZE bit, program x32
                STR     R1, [R0]                          ; store value into the FLASH_CR register
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller

Write_To_Flash
                PUSH    {R1-R12, LR}                      ; save register state
                STR     R1, [R0]                          ; store data into the sector 5 address
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller

Lock_Flash
                PUSH    {R1-R12, LR}                      ; save register state
                LDR     R0, =0x40023C10                   ; load address of the FLASH_CR register
                LDR     R1, [R0]                          ; load value inside FLASH_CR register
                MOV     R1, #0x80000000                   ; set the LOCK bit and clear everything else
                POP     {R1-R12, LR}                      ; repopulate register state
                BX      LR                                ; return to caller

Infinite_Loop
                B       .
;------------------------------------------------------------------------------------------------------------
                ENDP 
                ALIGN
                LTORG
;------------------------------------------------------------------------------------------------------------
NMI_Handler\
                PROC
                EXPORT  NMI_Handler                       [WEAK]
                B       .
                ENDP

HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler                 [WEAK]
                B       .
                ENDP

MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler                 [WEAK]
                B       .
                ENDP

BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler                  [WEAK]
                B       .
                ENDP

UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler                [WEAK]
                B       .
                ENDP

SVC_Handler\
                PROC
                EXPORT  SVC_Handler                       [WEAK]
                B       .
                ENDP

DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler                  [WEAK]
                B       .
                ENDP

PendSV_Handler\
                PROC
                EXPORT  PendSV_Handler                    [WEAK]
                B       .
                ENDP

SysTick_Handler\
                PROC
                EXPORT  SysTick_Handler                   [WEAK]
                B       .
                ENDP

Default_Handler\
                PROC
                EXPORT  WWDG_IRQHandler                   [WEAK]
                EXPORT  PVD_IRQHandler                    [WEAK]
                EXPORT  TAMP_STAMP_IRQHandler             [WEAK]
                EXPORT  RTC_WKUP_IRQHandler               [WEAK]
                EXPORT  FLASH_IRQHandler                  [WEAK]
                EXPORT  RCC_IRQHandler                    [WEAK]
                EXPORT  EXTI0_IRQHandler                  [WEAK]
                EXPORT  EXTI1_IRQHandler                  [WEAK]
                EXPORT  EXTI2_IRQHandler                  [WEAK]
                EXPORT  EXTI3_IRQHandler                  [WEAK]
                EXPORT  EXTI4_IRQHandler                  [WEAK]
                EXPORT  DMA1_Stream0_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream1_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream2_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream3_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream4_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream5_IRQHandler           [WEAK]
                EXPORT  DMA1_Stream6_IRQHandler           [WEAK]
                EXPORT  ADC_IRQHandler                    [WEAK]
                EXPORT  EXTI9_5_IRQHandler                [WEAK]
                EXPORT  TIM1_BRK_TIM9_IRQHandler          [WEAK]
                EXPORT  TIM1_UP_TIM10_IRQHandler          [WEAK]
                EXPORT  TIM1_TRG_COM_TIM11_IRQHandler     [WEAK]
                EXPORT  TIM1_CC_IRQHandler                [WEAK]
                EXPORT  TIM2_IRQHandler                   [WEAK]
                EXPORT  TIM3_IRQHandler                   [WEAK]
                EXPORT  TIM4_IRQHandler                   [WEAK]
                EXPORT  I2C1_EV_IRQHandler                [WEAK]
                EXPORT  I2C1_ER_IRQHandler                [WEAK]
                EXPORT  I2C2_EV_IRQHandler                [WEAK]
                EXPORT  I2C2_ER_IRQHandler                [WEAK]
                EXPORT  SPI1_IRQHandler                   [WEAK]
                EXPORT  SPI2_IRQHandler                   [WEAK]
                EXPORT  USART1_IRQHandler                 [WEAK]
                EXPORT  USART2_IRQHandler                 [WEAK]
                EXPORT  EXTI15_10_IRQHandler              [WEAK]
                EXPORT  RTC_Alarm_IRQHandler              [WEAK]
                EXPORT  OTG_FS_WKUP_IRQHandler            [WEAK]
                EXPORT  DMA1_Stream7_IRQHandler           [WEAK]
                EXPORT  SDIO_IRQHandler                   [WEAK]
                EXPORT  TIM5_IRQHandler                   [WEAK]
                EXPORT  SPI3_IRQHandler                   [WEAK]
                EXPORT  DMA2_Stream0_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream1_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream2_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream3_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream4_IRQHandler           [WEAK]
                EXPORT  OTG_FS_IRQHandler                 [WEAK]
                EXPORT  DMA2_Stream5_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream6_IRQHandler           [WEAK]
                EXPORT  DMA2_Stream7_IRQHandler           [WEAK]
                EXPORT  USART6_IRQHandler                 [WEAK]
                EXPORT  I2C3_EV_IRQHandler                [WEAK]
                EXPORT  I2C3_ER_IRQHandler                [WEAK]
                EXPORT  FPU_IRQHandler                    [WEAK]
                EXPORT  SPI4_IRQHandler                   [WEAK]
          
WWDG_IRQHandler

PVD_IRQHandler

TAMP_STAMP_IRQHandler

RTC_WKUP_IRQHandler

FLASH_IRQHandler

RCC_IRQHandler

EXTI0_IRQHandler

EXTI1_IRQHandler

EXTI2_IRQHandler

EXTI3_IRQHandler

EXTI4_IRQHandler

DMA1_Stream0_IRQHandler

DMA1_Stream1_IRQHandler

DMA1_Stream2_IRQHandler

DMA1_Stream3_IRQHandler

DMA1_Stream4_IRQHandler

DMA1_Stream5_IRQHandler

DMA1_Stream6_IRQHandler

ADC_IRQHandler

EXTI9_5_IRQHandler

TIM1_BRK_TIM9_IRQHandler

TIM1_UP_TIM10_IRQHandler

TIM1_TRG_COM_TIM11_IRQHandler

TIM1_CC_IRQHandler

TIM2_IRQHandler

TIM3_IRQHandler

TIM4_IRQHandler

I2C1_EV_IRQHandler

I2C1_ER_IRQHandler

I2C2_EV_IRQHandler

I2C2_ER_IRQHandler

SPI1_IRQHandler

SPI2_IRQHandler

USART1_IRQHandler

USART2_IRQHandler

EXTI15_10_IRQHandler

RTC_Alarm_IRQHandler

OTG_FS_WKUP_IRQHandler

DMA1_Stream7_IRQHandler

SDIO_IRQHandler

TIM5_IRQHandler

SPI3_IRQHandler

DMA2_Stream0_IRQHandler

DMA2_Stream1_IRQHandler

DMA2_Stream2_IRQHandler

DMA2_Stream3_IRQHandler

DMA2_Stream4_IRQHandler

OTG_FS_IRQHandler

DMA2_Stream5_IRQHandler

DMA2_Stream6_IRQHandler

DMA2_Stream7_IRQHandler

USART6_IRQHandler

I2C3_EV_IRQHandler

I2C3_ER_IRQHandler

FPU_IRQHandler

SPI4_IRQHandler
                
                B     .

                ENDP
                ALIGN
;------------------------------------------------------------------------------------------------------------
                END
;------------------------------------------------------------------------------------------------------------
