![image](https://github.com/mytechnotalent/STM32F401CCU6-Persistent-Flash-Driver/blob/main/STM32F401CCU6%20Flash%20Persistence%20Embedded%20Assembler.png?raw=true)

## FREE Reverse Engineering Self-Study Course [HERE](https://github.com/mytechnotalent/Reverse-Engineering-Tutorial)

<br>

# STM32F401CCU6 Persistent Flash Driver
STM32F401CCU6 persistent flash driver.

## Code
```
// MIT License
//
// Copyright (c) 2023 My Techno Talent
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// *******************************************************************************
// FILE: main.s
//
// DESCRIPTION:
// This file contains the assembly code for a program that creates persistent storage
// using the onboard flash utilizing the STM32F401CC6 microcontroller.
//
// AUTHOR: Kevin Thomas
// DATE: July 2, 2023
//
// USAGE:
// 1. Assemble and link the code using the STM32CubeIDE.
//
// 2. Run or debug the binary using the STM32CubeIDE.
//
// *******************************************************************************

.equ FLASH_INTERFACE_REGISTER_BASE,                 0x40023C00
.equ FLASH_KEYR,                                    FLASH_INTERFACE_REGISTER_BASE + 0x04
.equ FLASH_OPTKEYR,                                 FLASH_INTERFACE_REGISTER_BASE + 0x08
.equ FLASH_CR,                                      FLASH_INTERFACE_REGISTER_BASE + 0x10
.equ FLASH_SR,                                      FLASH_INTERFACE_REGISTER_BASE + 0x0C

.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.section .text

.global Reset_Handler
.global __start

Reset_Handler:
    ldr r0, =_estack                                // load the address of the _estack register into r0
    mov sp, r0                                      // set the stack pointer

__start:
    mov r0, #1
    bl Unlock_Flash                                 // call the Unlock_Flash function
    bl Erase_Sector_5_Flash                         // call the Erase_Sector_5_Flash function
    bl Verify_FLASH_SR_BSY_Bit_Cleared              // call the Verify_FLASH_SR_BSY_Bit_Cleared funtion
    bl Enable_Write_To_Flash                        // call the Enable_Write_To_Flash function
    ldr r0, =0x0803FFFC                             // address to write to within sector 5 flash
    ldr r1, =0xDEADBEEF                             // data to write into the sector 5 address
    bl Write_To_Flash                               // call the Write_To_Flash function
    bl Verify_FLASH_SR_BSY_Bit_Cleared              // call the Verify_FLASH_SR_BSY_Bit_Cleared function
    bl Lock_Flash                                   // call the Lock_Flash function
    bl Infinite_Loop                                // call the Infinite_Loop function

Unlock_Flash:
    push {r1-r12, lr}                               // save register state
    ldr r0, =FLASH_KEYR                             // load the address of the FLASH_KEYR register into r0
    ldr r1, =0x45670123                             // KEY1 value
    ldr r2, =0xCDEF89AB                             // KEY2 value
    str r1, [r0]                                    // store the value into the FLASH_KEYR register
    str r2, [r0]                                    // store the value into the FLASH_KEYR register
    ldr r0, =FLASH_OPTKEYR                          // load the address of the FLASH_OPTKEYR register into r0
    ldr r1, =0x08192A3B                             // OPTKEY1 value
    ldr r2, =0x4C5D6E7F                             // OPTKEY2 value
    str r1, [r0]                                    // store the value into the FLASH_OPTKEYR register
    str r2, [r0]                                    // store the value into the FLASH_OPTKEYR register
    pop {r1-r12, lr}                                // repopulate register state
    bx lr                                           // return to caller

Erase_Sector_5_Flash:
    push {r1-r12, lr}                               // save register state
    ldr r0, =FLASH_CR                               // load the address of the FLASH_CR register into r0
    ldr r1, [r0]                                    // load the value inside FLASH_CR into r1
    orr r1, r1, #0b00000000000000010000000000000000 // set the STRT bit
    orr r1, r1, #0b00000000000000000000000000100000 // set the SNB higher bit, sector 5
    orr r1, r1, #0b00000000000000000000000000001000 // set the SNB lower bit, sector 5
    orr r1, r1, #0b00000000000000000000000000000010 // set the SER bit
    str r1, [r0]                                    // store the value into the FLASH_CR register
    pop {r1-r12, lr}                                // repopulate register state
    bx lr                                           // return to caller

Verify_FLASH_SR_BSY_Bit_Cleared:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_SR                               // load the address of the FLASH_SR register into r0
    ldr r1, [R0]                                    // load the value inside FLASH_SR into r1
    tst r1, #0b00000000000000010000000000000000     // test the BSY bit
    bne Verify_FLASH_SR_BSY_Bit_Cleared             // branch back if BSY bit is still 1
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

Enable_Write_To_Flash:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_CR                               // load the address of the FLASH_CR register into r0
    ldr r1, [R0]                                    // load the value inside FLASH_CR into r1
    orr r1, r1, #0b00000000000000000000000000000001 // set the PG bit
    orr r1, r1, #0b00000000000000000000001000000000 // set the PSIZE highter bit, program x32
    bic r1, r1, #0b00000000000000000000000100000000 // clear the PSIZE lower bit, program x32
    str r1, [r0]                                    // store the value into the FLASH_CR register
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

Write_To_Flash:
    push {r1-r12,lr}                                // save register state
    str r1, [r0]                                    // store data into the sector 5 address
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

Lock_Flash:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_CR                               // load the address of the FLASH_CR register into r0
    ldr r1, [r0]                                    // load the value inside FLASH_CR into r1
    mov r1, #0b10000000000000000000000000000000     // set the LOCK bit and clear everything else
    str r1, [r0]                                    // store the value into the FLASH_CR register
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

Infinite_Loop:
    b Infinite_Loop                                 // infinite loop

.section .data

.section .bss

.align
.end
```

## Schematic
![image](https://github.com/mytechnotalent/STM32F401CCU6-Persistent-Flash-Driver/blob/main/STM32F401CCU6%20Schematic.jpg?raw=true)

## License
[MIT License](https://raw.githubusercontent.com/mytechnotalent/STM32F401CCU6-Persistent-Flash-Driver/main/LICENSE)
