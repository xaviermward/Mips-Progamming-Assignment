.data


invalid_string: .asciiz "String is invalid"
Create_Line: .asciiz "\n"
User_Input: .space 9


.text

main:


	#Get user input as text
	la $a0, User_Input
	li $a1, 9
	li $v0, 8
	syscall
 
	#Create_Line
	la $a0, Create_Line
	li $v0, 4
	syscall
 


	li $t1,0			#Get number of characters
    	la $t0,User_Input

loop:
	lb   $a0,0($t0)
    	beqz $a0,done
    	beq $a0, 10, done 
    
    	addi $t0,$t0,1
    	addi $t1,$t1,1
    	j     loop
done:
 
 	li   $v0,1
 	add  $a0, $0, $t1
    	#$t3 is the number of chars
   
add  $s3, $0, $t1 #s3 is length
	li $v0,1
	la $a0, ($s3)   

 
#array
	la $s1, User_Input 
	li $s0, 0 
 
 
	ori $s2,$zero,0 
	ori $s5,$zero,16 

	or $s4,$zero,$s3 	#while loop
 
while:
 
	lb $s0, 0($s1)
	addi $s1, $s1, 1
 
	beqz $s0,endWhile
        beq $s0, 10, endWhile
   
        subi $s4,$s4,1	#counter is decreased
    
        blt $s0, 48, error		#Range Check for Hex Characters
	blt $s0, 58, numbers
	blt $s0, 65, error
    	blt $s0, 71, uppercase
   	blt $s0, 97, error
    	blt $s0, 103, lowercase
    
    	bgt $s0, 102, error 
 
           
j while
 
 
error:
	li $v0, 4 #prints error string
	la $a0, invalid_string
	syscall
	li $v0, 10	#exit program
	syscall
numbers:
	sub $t0, $s0, 48 #translate to decimal
	ori $t4,$zero,1 #$t4 is multiple of 16
	ori $t5,$zero,0#counter
	beqz $s4, skip1

numWhile1:
	mult $t4,$s5
	mflo $t4
	addi $t5,$t5,1
	bne $t5,$s4,numWhile1
 
skip1: 
	mult $t0,$t4
	mflo $t0
	add $s2,$s2,$t0

j while

uppercase:
	sub $t0, $s0, 55 
	ori $t4,$zero,1 
	ori $t5,$zero,0
	beqz $s4, skip2

numWhile2:
	mult $t4,$s5
	mflo $t4
	addi $t5,$t5,1
	bne $t5,$s4,numWhile2
 skip2:
	mult $t0,$t4
	mflo $t0
	add $s2,$s2,$t0

j while

lowercase:
	sub $t0, $s0, 87 
	ori $t4,$zero,1 
	ori $t5,$zero,0
	beqz $s4, skip3
numWhile3:

	mult $t4,$s5
	mflo $t4
	addi $t5,$t5,1
	bne $t5,$s4,numWhile3
 skip3: 
	mult $t0,$t4
	mflo $t0
	add $s2,$s2,$t0
	j while
 
endWhile:

	la $a0, 0($s2)
	li $v0, 1 #11 for $t2
	syscall 
 
	la $a0, Create_Line
	li $v0, 4
	syscall
exit:
 
	li $v0, 10
	syscall
