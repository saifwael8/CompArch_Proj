import re

digits = {'1', '2', '3', '4', '5', '6', '7', '8', '9'}
letters = {'A', 'B', 'C', 'D', 'E', 'F'}

# Define opcodes for supported instructions
OPCODES = {
    "NOP": "00000",
    "HLT": "00001",
    "SETC": "00010",
    "NOT": "00011",
    "INC": "00100",
    "MOV": "00101",
    "AND": "00110",
    "ADD": "00111",
    "SUB": "01000",
    "IADD": "01001",
    "STD": "01010",
    "LDD": "01011",
    "LDM": "01100",
    "OUT": "01101",
    "IN": "01110",
    "PUSH": "01111",
    "POP": "10000",
    "JZ": "10001",
    "JN": "10010",
    "JC": "10011",
    "JMP": "10100",
    "CALL": "10101",
    "INT": "10110",
    "RET": "10111",
    "RTI": "11000",
    "RESET": "11111"
}

# Function to convert a register to its 3-bit binary representation
def register_to_bin(register):
    match = re.match(r"R(\d+)", register)
    if match:
        reg_num = int(match.group(1))
        if 0 <= reg_num <= 7:  # Ensure the register number is within range (0-7)
            return f"{reg_num:03b}"
    raise ValueError(f"Invalid register: {register}")

# Function to convert a hexadecimal number to binary
def hex_to_binary(hex_str):
    # Initialize an empty string to store the binary equivalent
    binary_str = ''
    
    # Loop through each character in the hexadecimal string
    for char in hex_str:
        # Convert the character to its hexadecimal equivalent and then to binary
        binary_char = bin(int(char, 16))[2:].zfill(4)  # Convert to binary and pad with leading zeros
        binary_str += binary_char  # Append the binary string
        
    return binary_str

# Function to assemble a single line of assembly code to machine code
def assemble_line(line):
    # parts = re.split(r",?\s+", line)
    parts = re.split(r'[,\s()]+', line.strip("()"))
    parts = [x for x in parts if x]
    opcode = parts[0].upper()

    if opcode in OPCODES:
        if opcode in {"HLT", "NOP", "SETC", "RET", "RTI", "RESET"}:
            return OPCODES[opcode] + "0" * 11  # No operands, pad with zeros

        if opcode in {"NOT", "INC", "MOV"}:
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires at least 1 operand.")
            dest = register_to_bin(parts[1])
            if len(parts) == 2: #if given 1 operand only for INC or NOT
                src = register_to_bin(parts[1])
            else:
                src = register_to_bin(parts[2])
            return OPCODES[opcode] + dest + src + "0" * 5


        if opcode in {"ADD", "SUB", "AND"}:
            if len(parts) < 4:
                raise ValueError(f"Instruction {opcode} requires 3 operands.")
            dest = register_to_bin(parts[1])
            src1 = register_to_bin(parts[2])
            src2 = register_to_bin(parts[3])
            return f"{OPCODES[opcode]}{dest}{src1}{src2}00"

            
        if opcode in {"POP", "IN"}:
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires 1 operand.")
            dest = register_to_bin(parts[1])
            return f"{OPCODES[opcode]}{dest}00000000"
        
        if opcode == "OUT":
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires 1 operand.")
            src = register_to_bin(parts[1])
            return f"{OPCODES[opcode]}000{src}00000"

        if opcode == "PUSH":
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires 1 operand.")
            src = register_to_bin(parts[1])
            return f"{OPCODES[opcode]}000000{src}00"

        if opcode == "LDM":
            if len(parts) < 3:
                raise ValueError(f"Instruction {opcode} requires 2 operands.")
            dest = register_to_bin(parts[1])
            immediate = parts[2]
            if (len(immediate) == 1 and immediate[0] == '0' or immediate[0] in digits) or (len(immediate) == 2 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 12 + hex_to_binary(immediate)
            elif (len(immediate) == 2 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 3 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 8 + hex_to_binary(immediate)
            elif (len(immediate) == 3 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 4 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 4 + hex_to_binary(immediate)
            elif (len(immediate) == 4 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 5 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = hex_to_binary(immediate)
            else:
                return "0" * 32
            
            if len(immediate_binary) == 20:
                immediate_binary = immediate_binary[4:]
            return f"{OPCODES[opcode]}{dest}00000000{immediate_binary}"
                
            
        if opcode in {"IADD", "LDD"}:
            if len(parts) < 4:
                raise ValueError(f"Instruction {opcode} requires 3 operands.")
            dest = register_to_bin(parts[1])
            if opcode == "LDD":
                src = register_to_bin(parts[3])
                immediate = parts[2]
            else:
                src = register_to_bin(parts[2])
                immediate = parts[3]        
            
            if (len(immediate) == 1 and immediate[0] == '0' or immediate[0] in digits) or (len(immediate) == 2 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 12 + hex_to_binary(immediate)
            elif (len(immediate) == 2 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 3 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 8 + hex_to_binary(immediate)
            elif (len(immediate) == 3 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 4 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 4 + hex_to_binary(immediate)
            elif (len(immediate) == 4 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 5 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = hex_to_binary(immediate)
            else:
                return "0" * 32
            
            if len(immediate_binary) == 20:
                immediate_binary = immediate_binary[4:]            
            return f"{OPCODES[opcode]}{dest}{src}00000{immediate_binary}"
        
        if opcode == "STD":
            if len(parts) < 4:
                raise ValueError(f"Instruction {opcode} requires 3 operands.")
            src = register_to_bin(parts[1])
            address = register_to_bin(parts[3])
            immediate = parts[2]
            
            if (len(immediate) == 1 and immediate[0] == '0' or immediate[0] in digits) or (len(immediate) == 2 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 12 + hex_to_binary(immediate)
            elif (len(immediate) == 2 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 3 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 8 + hex_to_binary(immediate)
            elif (len(immediate) == 3 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 4 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = "0" * 4 + hex_to_binary(immediate)
            elif (len(immediate) == 4 and immediate[0] in digits and immediate[1] in digits) or (len(immediate) == 5 and immediate[0] == '0' and immediate[1] in letters):
                immediate_binary = hex_to_binary(immediate)
            else:
                return "0" * 32
            
            if len(immediate_binary) == 20:
                immediate_binary = immediate_binary[4:]            
            return f"{OPCODES[opcode]}000{address}{src}00{immediate_binary}"
            

        if opcode in {"JZ", "JN", "JC", "JMP", "CALL"}:
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires 1 operand.")
            src = register_to_bin(parts[1])
            return f"{OPCODES[opcode]}000{src}00000"
        
        if opcode == "INT":
            if len(parts) < 2:
                raise ValueError(f"Instruction {opcode} requires 1 operand.")
            i = register_to_bin(parts[1])
            return f"{OPCODES[opcode]}{i}0000000000"

    else:
        raise ValueError(f"Unsupported instruction: {opcode}")


# Function to process .ORG directives and update the output file

# def handle_org(line):
#     current_address = bin(int(line.split()[1], 12))[2:]
#     machine_code[current_address] = 
    

#bin(int("600", 12))[2:]

# Function to assemble an entire file
def assemble_file(input_file, output_file):
    current_address = 0
    machine_code = {address: "0"*16 for address in range(4096)}

    with open(input_file, "r") as infile, open(output_file, "w") as outfile:
        for line in infile:
            line = line.strip()
            if not line or line.startswith("#"):  # Ignore empty lines and comments
                continue

            # Handle .ORG directives
            if line.upper().startswith(".ORG"):
                current_address = hex_to_binary(line.split()[1])
                continue

            try:
                if line[0] in digits or (line[0] == '0' and line[1] in letters):                    
                    code = format(hex(int(line)), "016b")
                    address_bin = format(current_address, "012b")
                    machine_code[int(current_address)] = code
                    current_address += 1
            except ValueError as e:
                print(f"Error processing line: {line}\n{e}")

        # Write the machine code to the output file
        for address in sorted(machine_code):
            outfile.write(f"{address:04X}: {machine_code[address]}\n")

# Main entry point
if __name__ == "__main__":
    input_file = "AssemblyExample.asm.txt"  # Replace with your input file name if different
    output_file = "output.mc"          # Replace with your desired output file name
    assemble_file(input_file, output_file)
    print(f"Assembly complete. Machine code written to {output_file}")
