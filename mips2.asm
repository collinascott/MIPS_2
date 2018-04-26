.data
	string1: .space 1001   
	string2: .asciiz "NaN"
	string3: .ascii "too large"
	eachString: .word 0:10001 # array holds comma seperated string
	decimalValue: .word 0:8   # array holds values to be added up
.text	
	main: 

	li $v0, 8              	
	la $a0, string1           
	li $a1, 10001          
	syscall	          
	add $t1, $a0, $zero    
	addi $t3, $zero, 0     # eachString index = 0
	addi $t6, $zero, 0     # initialize $t6 = 0
	addi $a3, $zero, 0     # $a3 = 0 (End Code)	   
	   
resetCounter:	add $t4, $zero, $zero # initializing the counter 
                add $t5, $zero, $zero               # initialize empty string counter
                add $t3, $zero, $zero               # index for string array
jumptobeginning:  lb $t2, 0($t1)                     
                beq $t2, 44, selectionProcess       
                beq $t2, 0, EndtheCode 
                beq $t2, 10, EndtheCode              


continue:       sb $t2, eachString($t3)             # load string into array
                addi $t4, $t4, 1                    
                addi $t3, $t3, 1                    
                addi $t1, $t1, 1                    
                seq $s2, $t2, 32	            # if the character is a space
                beq $s2, 1, emptyString             # if the character is a space, count spaces
	        j jumptobeginning                     
	                      
selectionProcess: addi $t1, $t1, 1                  # incrment to the next character after the comma
                  beq $t4, 0, printNaN              # if the only character checked was a comma print NaN
                  beq $t5, $t4, printNaN            # if the string is empty, print NaN          
                  sgt $s1, $t4, 8                   
                  beq $s1, 1, printTooLong          
                  j StartLoop
                  
emptyString:      addi $t5, $t5, 1       
                  j jumptobeginning        
	             	        	          	        	   	             	        	          	                       	          	        	        
StartLoop:   addi $t5, $zero, 0          # initialize $t5 index 
CheckeachString: lb $t2, eachString($t5)     # loads byte into $t2 
             sge $s0, $t2, 48            
             sle $s1, $t2, 57            
             beq $s0, 1, Test1Condition2 # character is greater than or equal to '0'
             j Test2Condition1           

Test1Condition2: bne $s1, 1, Test2Condition1 # if $s1 was not set, move to next test        
                 j NextChar                  # passes first test

Test2Condition1: sge $s2, $t2, 97            # character is 'a' or above 'a' 
                 sle $s3, $t2, 102           # character is 'f' or below 'f'       
                 beq $s2, 1, Test2Condition2  
                 j Test3Condition1          

Test2Condition2: bne $s3, 1, Test3Condition1 
                 j NextChar                 

Test3Condition1: sge $s4, $t2, 65            # character is 'A' or above 'A' 
                 sle $s5, $t2, 70            # character is 'F' or below 'F'    
                 beq $s4, 1, Test3Condition2 
                 j printNaN                             

Test3Condition2: bne $s5, 1, printNaN       
                 j NextChar                          

NextChar:  addi $t5, $t5, 1                  
           beq $t5, $t4, EndHexCheck         # EXITS the LOOP 
	   j CheckeachString                     
	  	  	  
EndHexCheck: jal subProgram2	  	       	        	           	        	            	        	           	        	            	        	           	        	        	       	        	           	        	            	        	           	        	            	        	           	        	        
             jal subProgram3           	        	           	        	           	        	        	             	        	           	        	           	        	        
	     j resetCounter 
	            	        	           	              	        	           	        	           	        	           	        	           	        	               
EndtheCode: addi $a3, $zero, 1
               j selectionProcess        	        	        
	        	        	        	        	        
subProgram2:  add $t0, $ra, $zero         
              addi $t5, $zero, 0          
	      addi $t7, $zero, 0          
CheckString2: addi $t8, $zero, 0          # initilize switch digit 0 - 9 is found 
              addi $s6, $zero, 0          # initilize switch digit a - f is found 
              addi $s7, $zero, 0          # initilize switch digit A - F is found 
              beq $t5, $t4, AddTheValues  # subprogram works the same as he previous section that tests for hex characters
              lb $t2, eachString($t5)      
              sge $s0, $t2, 48            
              sle $s1, $t2, 57            
              beq $s0, 1, Test1Part2      
              j Test2Part1                
	   
Test1Part2: bne $s1, 1, Test2Part1        
            addi $t8, $zero, 1           
            jal subProgram1                   
            j CheckString2                   

Test2Part1: sge $s2, $t2, 97               
            sle $s3, $t2, 102                   
            beq $s2, 1, Test2Part2       
            j Test3Part1                 

Test2Part2: bne $s3, 1, Test3Part1        
            addi $s6, $zero, 1            
            jal subProgram1              
            j CheckString2               

Test3Part1: sge $s4, $t2, 65            
            sle $s5, $t2, 70              
            beq $s4, 1, Test3Part2      
            j printNaN                             

Test3Part2: bne $s5, 1, printNaN        
            addi $s7, $zero, 1          
            jal subProgram1             
            j CheckString2             	   
	   	   	   
AddTheValues:   add $t8, $zero, $zero        # initialize $t8, index of
                beq $t4, 1, oneElement       
                beq $t4, 2, twoElements      
                beq $t4, 3, threeElements    
                beq $t4, 4, fourElements     
                beq $t4, 5, fiveElements     # branch to different sub functions based on the length of string
                beq $t4, 6, sixElements
                beq $t4, 7, sevenElements
                beq $t4, 8, eightElements

oneElement: add $t9, $zero, $zero            # initialize $t9, index of
            lb $t5, decimalValue($t9)        # loads the value from array element
            add $t8, $t5, $zero              # calculate sum
            addi $sp, $sp, -4                # PUSH $t8 (total value) ONTO THE STACK
            sw $t8, 0($sp)                   # PUSH $t8 (total value) ONTO THE STACK
            add $ra, $t0, $zero              # get the return address for the firt subprogram call
            jr $ra                           # return to calling subprogram
        

twoElements: add $t9, $zero, $zero        
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16            # use this register to multiply by 16
             multu $t5, $t6                 # multiply value by 16
             mflo $t8                       # put result in $t8
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             add $t8, $t8, $t5              # calculate sum
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram
             
threeElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 256           # multiply value by 256 which is in $t6
             multu $t5, $t6                 # multiply the value by 256
             mflo $t8                       # store result in $t8 
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16
             multu $t5, $t6
             mflo $t7     
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             add $t8, $t8, $t5              # calculate sum
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram

fourElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 4096          # mulitply corresponding  value by 4096
             multu $t5, $t6                 # multiply value by 4096
             mflo $t8                       # store result in $t8
             addi $t9, $t9, 1               # Increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 256
             multu $t5, $t6 
             mflo $t7
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             add $t8, $t8, $t5              # calculate sum
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram

fiveElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 65536         # add cooresponding value to 65536
             multu $t5, $t6                 # carry out the multiplication
             mflo $t8                       # store result in $t8
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 4096
             multu $t5, $t6 
             mflo $t7
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 256  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)      # loads the value from array element    
             add $t8, $t8, $t5              # calculate sum  
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram

sixElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 1048576       # add cooresponding value to 1048576
             multu $t5, $t6                 # carry out the multiplication
             mflo $t8                       # store result in $t8
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 65536
             multu $t5, $t6 
             mflo $t7
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 4096  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 256  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)      # loads the value from array element  
             addi $t6, $zero, 16  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1  
             lb $t5, decimalValue($t9)      # loads the value from array element        
             add $t8, $t8, $t5              # calculate sum 
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram


sevenElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16777216      # add cooresponding value to 16777216
             multu $t5, $t6                 # carry out the multiplication
             mflo $t8                       # store result in $t8
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 1048576
             multu $t5, $t6 
             mflo $t7
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 65536  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 4096 
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)      # loads the value from array element  
             addi $t6, $zero, 256  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1  
             lb $t5, decimalValue($t9)      # loads the value from array element 
             addi $t6, $zero, 16  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)       
             add $t8, $t8, $t5              # calculate sum 
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram


eightElements: add $t9, $zero, $zero
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 268435456     # add cooresponding value to 268435456
             multu $t5, $t6                 # carry out the multiplication
             mflo $t8                       # store result in $t8
             addi $t9, $t9, 1               # increment $t9
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 16777216
             multu $t5, $t6 
             mflo $t7
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 1048576  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1
             lb $t5, decimalValue($t9)      # loads the value from array element
             addi $t6, $zero, 65536 
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)      # loads the value from array element  
             addi $t6, $zero, 4096  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1  
             lb $t5, decimalValue($t9)      # loads the value from array element 
             addi $t6, $zero, 256  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1 
             lb $t5, decimalValue($t9)
             addi $t6, $zero, 16  
             multu $t5, $t6 
             mflo $t7   
             add $t8, $t8, $t7              # calculate sum
             addi $t9, $t9, 1   
             lb $t5, decimalValue($t9)    
             add $t8, $t8, $t5              # calculate sum 
             addi $sp, $sp, -4              # PUSH $t8 (total value) ONTO THE STACK
             sw $t8, 0($sp)                 # PUSH $t8 (total value) ONTO THE STACK
             add $ra, $t0, $zero            # get the return address for the firt subprogram call
             jr $ra                         # return to calling subprogram
	   
################################################ subprogram1 converts each hex character to its decimal number and saves it in an array
	   	   
subProgram1:  beq $t8, 1, decimalDigitFound    # if a 0 - 9 
              beq $s6, 1, lowercaseFound       # if a a - f 
              beq $s7, 1, uppercaseFound       # if a A - F 
decimalDigitFound: addi $t6, $t2, -48          
                   sb $t6, decimalValue($t7)   
                   addi $t7, $t7, 1            
                   addi $t5, $t5, 1            
                   j CheckString2              
                   
lowercaseFound:    addi $t6, $t2, -87          
                   sb $t6, decimalValue($t7)  
                   addi $t7, $t7, 1            
                   addi $t5, $t5, 1            
                   j CheckString2              
 
uppercaseFound:    addi $t6, $t2, -55          
                   sb $t6, decimalValue($t7)   
                   addi $t7, $t7, 1            
                   addi $t5, $t5, 1            
                   j CheckString2            

subProgram3:  lw $t8, 0($sp)    # pop value off stack   
              addi $sp, $sp, 4  # pop value off stack
              li $v0, 1         # 
              la $a0, ($t8)     # 
              syscall           
              li $v0, 11        
              la $a0, ','       # print a comma
              syscall           
              beq $a3, 1, EndOfCode
              jr $ra
printNaN:       li $v0, 4     
	        la $a0, string2  # print error message
	        syscall	      
	        li $v0, 11    
	        li $a0, ','     
	        syscall      
	        beq $a3, 1, EndOfCode
	        j resetCounter  
printTooLong:   li $v0, 4    
	        la $a0, string3  # print error message
	        syscall	      
	        li $v0, 11    
	        li $a0, ','    
	        syscall       
	        beq $a3, 1 EndOfCode
	        j resetCounter 
	        
EndOfCode:      li $v0, 10
	        syscall