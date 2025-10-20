from sys import argv
from src.input_processor import process_input


def main():
    if len(argv) != 2:
        raise Exception("File path not entered")
    file_path = argv[1]
    with open(file_path, "r") as f:
        Lines = f.readlines()
    inputs = []
    for line in Lines:
        input_params = line.strip().split(" ")
        inputs.append(input_params)

    process_input(inputs)


if __name__ == "__main__":
    main()
