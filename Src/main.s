/**********************************************************************************************************
 * MIT License
 *
 * Copyright (c) 2023 My Techno Talent
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *********************************************************************************************************/

/**********************************************************************************************************
 * FILE: main.s
 *
 * DESCRIPTION:
 * This file contains the assembly code for a program that creates persistent storage
 * using the onboard flash utilizing the STM32F401CC6 microcontroller.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * 1. Assemble and link the code using the STM32CubeIDE.
 * 2. Run or debug the binary using the STM32CubeIDE.
 *
 *********************************************************************************************************/

/**********************************************************************************************************
 * MEMORY ADDRESS DEFINITIONS
 *
 * DESCRIPTION:
 * This code block defines memory address constants related to the flash memory
 * interface registers. It includes addresses such as FLASH_KEYR, FLASH_OPTKEYR,
 * FLASH_CR, and FLASH_SR. These constants represent the base address of the flash
 * interface register block (FLASH_INTERFACE_REGISTER_BASE) plus specific offsets
 * for each register.
 *
 * USAGE:
 * The memory address constants defined in this code block can be used to access
 * and manipulate the flash interface registers in the system. They provide an
 * abstraction layer for the memory addresses, making the code more readable and
 * maintainable.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Ensure that the FLASH_INTERFACE_REGISTER_BASE constant is correctly set to
 *   the base address of the flash interface register block in your system.
 * - Verify the accuracy of the offsets used to define the specific register
 *   addresses (e.g., FLASH_KEYR, FLASH_OPTKEYR, FLASH_CR, FLASH_SR).
 *********************************************************************************************************/
.equ FLASH_INTERFACE_REGISTER_BASE,                 0x40023C00
.equ FLASH_KEYR,                                    FLASH_INTERFACE_REGISTER_BASE + 0x04
.equ FLASH_OPTKEYR,                                 FLASH_INTERFACE_REGISTER_BASE + 0x08
.equ FLASH_CR,                                      FLASH_INTERFACE_REGISTER_BASE + 0x10
.equ FLASH_SR,                                      FLASH_INTERFACE_REGISTER_BASE + 0x0C

/**********************************************************************************************************
 * ASSEMBLY CONFIGURATION
 *
 * DESCRIPTION:
 * This assembly code block sets the configuration for the assembly language.
 * It specifies the syntax as unified, the CPU as Cortex-M4, the FPU as SoftVFP,
 * and the instruction set as Thumb. These settings determine how the assembly
 * code is written, compiled, and executed by the target system.
 *
 * USAGE:
 * Include this code block at the beginning of the assembly file to configure
 * the assembly language settings according to the specific system requirements.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Verify that the specified CPU and FPU match the target system's architecture
 *   and capabilities.
 * - Adjust the instruction set (Thumb or ARM) based on the target system's
 *   instruction set support and requirements.
 *********************************************************************************************************/
.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

/**********************************************************************************************************
 * TEXT SECTION DEFINITION
 *
 * DESCRIPTION:
 * This assembly code block defines the section as ".text". The ".text" section
 * is commonly used to store the executable code of a program or application.
 * It contains the instructions that the processor executes when the program is
 * running.
 *
 * USAGE:
 * Include this code block in the assembly file to specify that the following
 * code should be placed in the ".text" section of the compiled binary.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Ensure that the subsequent code in the assembly file is intended to be
 *   part of the executable code and belongs to the ".text" section.
 *********************************************************************************************************/
.section .text

/**********************************************************************************************************
 * GLOBAL SYMBOL DECLARATION
 *
 * DESCRIPTION:
 * This assembly code block declares the global symbols `Reset_Handler` and
 * `__start`. Global symbols are labels that can be accessed from other modules
 * or files. These symbols are commonly used in embedded systems and serve as
 * entry points or important function references.
 *
 * USAGE:
 * Include this code block in the assembly file to declare the `Reset_Handler`
 * and `__start` symbols as global. This allows other modules or files to refer
 * to these symbols and utilize their functionality.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Ensure that the subsequent code in the assembly file defines the actual
 *   implementation of the declared symbols.
 * - Verify that the names `Reset_Handler` and `__start` align with the intended
 *   entry points or function references in the system.
 *********************************************************************************************************/
.global Reset_Handler
.global __start

/**********************************************************************************************************
 * FUNCTION NAME: Reset_Handler
 *
 * DESCRIPTION:
 * This function is the reset handler, which is called when the microcontroller
 * starts up or resets. It initializes the stack pointer (SP) to the address of
 * the stack base, denoted by the symbol _estack.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * This function is automatically called at startup or after a reset. It should
 * not be called explicitly in user code.
 *
 * NOTES:
 * - This function assumes that the stack base (_estack) has been properly
 *   defined in the system.
 *********************************************************************************************************/
Reset_Handler:
    ldr r0, =_estack                                // load the address of the _estack register into r0
    mov sp, r0                                      // set the stack pointer

/**********************************************************************************************************
 * FUNCTION NAME: __start
 *
 * DESCRIPTION:
 * This function is the entry point of the program. It performs a series of flash
 * memory operations, including unlocking, erasing, writing, and locking. It also
 * verifies the status of the flash memory before and after each operation.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * The "__start" function serves as the entry point of the program and is
 * automatically called at startup. It initializes the flash memory and performs
 * a series of flash operations. This function should not be explicitly called
 * within user code.
 *
 * NOTES:
 * - This function assumes that the necessary flash control sequences and
 *   permissions have been properly configured in the system.
 * - The function relies on the existence and correctness of the called functions,
 *   such as Unlock_Flash, Erase_Sector_5_Flash, Verify_FLASH_SR_BSY_Bit_Cleared,
 *   Enable_Write_To_Flash, Write_To_Flash, Lock_Flash, and Infinite_Loop.
 *********************************************************************************************************/
__start:
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

/**********************************************************************************************************
 * FUNCTION NAME: Unlock_Flash
 *
 * DESCRIPTION:
 * This function unlocks the flash memory for write access by configuring the
 * necessary key values in the FLASH_KEYR and FLASH_OPTKEYR registers.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to unlock the flash memory before performing write
 * operations on it.
 *
 * NOTES:
 * - This function assumes that the necessary flash unlocking sequences and
 *   permissions have been correctly configured in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Unlock_Flash:
    push {r1-r12, lr}                               // save register state
    ldr r0, =FLASH_KEYR                             // load address of the FLASH_KEYR register into r0
    ldr r1, =0x45670123                             // load KEY1 value inside FLASH_KEYR into r1
    ldr r2, =0xCDEF89AB                             // load KEY2 value inside FLASH_KEYR into r2
    str r1, [r0]                                    // store the value into the FLASH_KEYR register
    str r2, [r0]                                    // store the value into the FLASH_KEYR register
    ldr r0, =FLASH_OPTKEYR                          // load address of the FLASH_OPTKEYR register into r0
    ldr r1, =0x08192A3B                             // load OPTKEY1 value inside FLASH_OPTKEYR into r1
    ldr r2, =0x4C5D6E7F                             // load OPTKEY2 value inside FLASH_OPTKEYR into r2
    str r1, [r0]                                    // store value into the FLASH_OPTKEYR register
    str r2, [r0]                                    // store value into the FLASH_OPTKEYR register
    pop {r1-r12, lr}                                // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Erase_Sector_5_Flash
 *
 * DESCRIPTION:
 * This function erases Sector 5 of the flash memory by setting the necessary
 * control bits in the FLASH_CR register.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to erase Sector 5 of the flash memory.
 *
 * NOTES:
 * - This function assumes that the necessary flash erasure sequences and
 *   permissions have been correctly configured in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Erase_Sector_5_Flash:
    push {r1-r12, lr}                               // save register state
    ldr r0, =FLASH_CR                               // load address of the FLASH_CR register into r0
    ldr r1, [r0]                                    // load value inside FLASH_CR into r1
    orr r1, r1, #0b00000000000000010000000000000000 // set the STRT bit
    orr r1, r1, #0b00000000000000000000000000100000 // set the SNB higher bit, sector 5
    orr r1, r1, #0b00000000000000000000000000001000 // set the SNB lower bit, sector 5
    orr r1, r1, #0b00000000000000000000000000000010 // set the SER bit
    str r1, [r0]                                    // store value into the FLASH_CR register
    pop {r1-r12, lr}                                // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Verify_FLASH_SR_BSY_Bit_Cleared
 *
 * DESCRIPTION:
 * This function verifies that the BSY (Busy) bit in the FLASH_SR register is
 * cleared, indicating that the flash memory is no longer busy with an ongoing
 * operation.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to check if the BSY bit in the FLASH_SR register is
 * cleared, indicating that the flash memory is not busy.
 *
 * NOTES:
 * - This function assumes that the FLASH_SR register has been correctly
 *   configured in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Verify_FLASH_SR_BSY_Bit_Cleared:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_SR                               // load address of the FLASH_SR register into r0
    ldr r1, [R0]                                    // load value inside FLASH_SR into r1
    tst r1, #0b00000000000000010000000000000000     // test the BSY bit
    bne Verify_FLASH_SR_BSY_Bit_Cleared             // branch back if BSY bit is still 1
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Enable_Write_To_Flash
 *
 * DESCRIPTION:
 * This function enables write access to the flash memory by setting the necessary
 * control bits in the FLASH_CR register.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to enable write access to the flash memory.
 *
 * NOTES:
 * - This function assumes that the necessary flash write enable sequences and
 *   permissions have been correctly configured in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Enable_Write_To_Flash:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_CR                               // load address of the FLASH_CR register into r0
    ldr r1, [R0]                                    // load value inside FLASH_CR into r1
    orr r1, r1, #0b00000000000000000000000000000001 // set the PG bit
    orr r1, r1, #0b00000000000000000000001000000000 // set the PSIZE highter bit, program x32
    bic r1, r1, #0b00000000000000000000000100000000 // clear the PSIZE lower bit, program x32
    str r1, [r0]                                    // store value into the FLASH_CR register
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Write_To_Flash
 *
 * DESCRIPTION:
 * This function writes a specified data value into a target address within sector
 * 5 of the flash memory. It saves the register state, stores the data into the
 * specified address, and then restores the register state before returning to the
 * caller. The target address and data value are passed as input parameters to this
 * function.
 *
 * INPUTS:
 * - r0: Address to write the data into within sector 5 of the flash memory.
 * - r1: Data value to be written into the specified address.
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to write a specified data value into a target address within
 * sector 5 of the flash memory. Provide the target address in r0 and the data value
 * in r1 as input parameters when calling this function.
 *
 * NOTES:
 * - This function assumes that the specified address falls within sector 5 of the
 *   flash memory and that the flash write operations have been properly configured
 *   and enabled in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Write_To_Flash:
    push {r1-r12,lr}                                // save register state
    str r1, [r0]                                    // store data into the sector 5 address
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Lock_Flash
 *
 * DESCRIPTION:
 * This function locks the flash memory by setting the LOCK bit in the FLASH_CR
 * register, preventing any further write access to the flash memory.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * Call this function to lock the flash memory, preventing any further write access.
 *
 * NOTES:
 * - This function assumes that the necessary flash locking sequences and
 *   permissions have been correctly configured in the system.
 * - The function saves and restores the state of registers r1-r12 and lr.
 *********************************************************************************************************/
Lock_Flash:
    push {r1-r12,lr}                                // save register state
    ldr r0, =FLASH_CR                               // load address of the FLASH_CR register into r0
    ldr r1, [r0]                                    // load value inside FLASH_CR into r1
    mov r1, #0b10000000000000000000000000000000     // set the LOCK bit and clear everything else
    str r1, [r0]                                    // store value into the FLASH_CR register
    pop {r1-r12,lr}                                 // repopulate register state
    bx lr                                           // return to caller

/**********************************************************************************************************
 * FUNCTION NAME: Infinite_Loop
 *
 * DESCRIPTION:
 * This function creates an infinite loop, causing the program execution to remain
 * indefinitely within this loop. It serves as a blocking mechanism to ensure that
 * the program continues to run without exiting or terminating.
 *
 * INPUTS:
 * None
 *
 * OUTPUTS:
 * None
 *
 * RETURNS:
 * None
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * USAGE:
 * The "Infinite_Loop" function is used to create an infinite loop within the program.
 * It should be called when a blocking mechanism or continuous program execution is
 * desired. This function should not be explicitly called within user code.
 *
 * NOTES:
 * - This function causes the program execution to be trapped within an infinite loop
 *   and will only exit or terminate if an external interrupt or reset event occurs.
 * - Ensure that proper interrupt handling and reset mechanisms are in place to
 *   prevent the program from being stuck in this infinite loop indefinitely.
 *********************************************************************************************************/
Infinite_Loop:
    b Infinite_Loop                                 // infinite loop

/**********************************************************************************************************
 * DATA SECTION DEFINITION
 *
 * DESCRIPTION:
 * This assembly code block defines the section as ".data". The ".data" section
 * is commonly used to store initialized data that will be accessible and
 * modifiable during program execution. It typically includes global and static
 * variables, constants, and initialized arrays.
 *
 * USAGE:
 * Include this code block in the assembly file to specify that the following
 * data declarations should be placed in the ".data" section of the compiled
 * binary. This section is where initialized data resides and is accessible for
 * read and write operations.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Ensure that the subsequent data declarations in the assembly file are
 *   intended to be part of the initialized data section and belong to the
 *   ".data" section.
 *********************************************************************************************************/
.section .data

/**********************************************************************************************************
 * BSS SECTION DEFINITION
 *
 * DESCRIPTION:
 * This assembly code block defines the section as ".bss". The ".bss" section is
 * commonly used to allocate space for uninitialized or zero-initialized
 * variables. It typically includes static and global variables that do not
 * require explicit initialization.
 *
 * USAGE:
 * Include this code block in the assembly file to specify that the subsequent
 * variable declarations should be placed in the ".bss" section of the compiled
 * binary. This section is where memory is reserved for variables that will be
 * initialized to zero or left uninitialized.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Ensure that the subsequent variable declarations in the assembly file are
 *   intended to be part of the uninitialized or zero-initialized data and
 *   belong to the ".bss" section.
 *********************************************************************************************************/
.section .bss

/**********************************************************************************************************
 * ALIGN AND END DIRECTIVES
 *
 * DESCRIPTION:
 * This assembly code block includes the `.align` and `.end` directives. The
 * `.align` directive is used to align the following code or data on a specific
 * memory boundary. The `.end` directive marks the end of the assembly file.
 *
 * USAGE:
 * Include this code block in the assembly file to specify alignment requirements
 * and mark the end of the file. The `.align` directive ensures that the
 * subsequent code or data is aligned according to the specified boundary. The
 * `.end` directive denotes the end of the assembly file.
 *
 * AUTHOR: Kevin Thomas
 * DATE: July 2, 2023
 *
 * NOTES:
 * - Adjust the alignment value in the `.align` directive as per your specific
 *   requirements.
 * - Ensure that the `.end` directive is placed at the end of the assembly file.
 * - Additional directives or code can be added after the `.end` directive.
 *********************************************************************************************************/
.align
.end
