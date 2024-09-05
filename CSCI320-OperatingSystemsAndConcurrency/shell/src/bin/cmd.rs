use std::fs;
use std::env;
use std::io::Read;
use std::io::{self, BufRead};
use std::fs::File;

fn main() {
    let mut parameters = Vec::new();
    for arg in std::env::args() {
        parameters.push(arg);
    }
    let function = parameters[1].clone();
    let arguments = parameters[2..].to_vec();
    if function == "dir" {
        dir()
    } else if function == "destroy" {
        destroy(arguments)
    } else if function == "newname" {
        newname(arguments)
    } else if function == "duplicate" {
        duplicate(arguments)
    } else if function =="start" {
        start(arguments)
    } else if function =="counter" {
        counter(arguments)
    } else if function =="findtext" {
        findtext(arguments) 
    } else if function =="order" {
        order(arguments) 
    }else {
        println!("Error, invalid command");
    }
}

fn dir() {
    let current_directory = env::current_dir().unwrap();
    let paths = fs::read_dir(current_directory).unwrap();
    for path in paths {
        let entry = path.unwrap();
        let file_name = entry.file_name();
        println!("{}", file_name.to_string_lossy());
    }
}

fn destroy(files: Vec<String>) {
    for file in files {
        match fs::remove_file(&file) {
            Ok(_) => println!("Deleted file: {}", file),
            Err(e) => eprintln!("Failed to delete {}: {}", file, e),
        }
    }
}

fn newname(files: Vec<String>) {
    let original_name = files[0].clone();
    let new_name = files[1].clone();
    match fs::rename(&original_name, &new_name) {
        Ok(_) => println!("Renamed: {}, to {}", original_name, new_name),
        Err(e) => eprintln!("Failed to rename {} to {}: {}", original_name, new_name, e),
    }
}

fn duplicate(files: Vec<String>) {
    let original_file = files[0].clone();
    let new_file = files[1].clone();
    match fs::copy(&original_file, &new_file) {
        Ok(_) => println!("Renamed: {}, to {}", original_file, new_file),
        Err(e) => eprintln!("Failed to rename {} to {}: {}", original_file, new_file, e),
    }
}

fn start(arguments: Vec<String>) {
    let mut head_size = 10;
    let files:Vec<String>; 

    if !arguments.is_empty() && arguments[0].starts_with("-") {
        if let Ok(n) = arguments[0][1..].parse::<usize>() {
            head_size = n;
        }
        files = arguments[1..].to_vec();
    } else {
        files = arguments;
    }

    for file in files {
        match File::open(&file) {
            Ok(f) => {
                let reader = io::BufReader::new(f);
                println!("--- First {} lines of {} ---", head_size, file);
                for (index, line) in reader.lines().enumerate() {
                    if index >= head_size {
                        break;
                    }
                    match line {
                        Ok(content) => println!("{}", content),
                        Err(e) => eprintln!("Error reading line: {}", e),
                    }
                }

            }
            Err(e) => eprintln!("Failed to open {}: {}", file, e),
        }
    }
}

fn counter(arguments: Vec<String>) {
    let mut count_words = true;
    let mut count_lines = true;
    let mut count_chars = true;
    let files:Vec<String>; 

    if !arguments.is_empty() && arguments[0].starts_with("-") {
        let options = &arguments[0][1..];
        count_words = options.contains('w');
        count_lines = options.contains('l');
        count_chars = options.contains('c');

        if !count_words && !count_lines && !count_chars {
            count_words = true;
            count_lines = true;
            count_chars = true;
        }

        files = arguments[1..].to_vec();

    } else {
        files = arguments;
    }

    for file in files {
        match File::open(&file) {
            Ok(mut f) => {
                let mut content = String::new();
                f.read_to_string(&mut content).unwrap();

                let num_words = content.split_whitespace().count();
                let num_lines = content.lines().count();
                let num_chars = content.chars().count();

                println!("File: {}", file);
                if count_words {
                    println!("Words: {}", num_words);
                }
                if count_lines {
                    println!("Lines: {}", num_lines);
                }
                if count_chars {
                    println!("Characters: {}", num_chars);
                }
            }
            Err(e) => eprintln!("Failed to open {}: {}", file, e),
        }
    }
}

fn findtext(arguments: Vec<String>) {
    if arguments.is_empty() {
        eprint!("Error: no pattern provided.");
        return;
    }

    let pattern = &arguments[0];
    let files = &arguments[1..];

    for file in files {
        match File::open(&file) {
            Ok(f) => {
                let reader = io::BufReader::new(f);
                println!("--- Matches in {} ---", file);
                for line in reader.lines() {
                    match line {
                        Ok(content) => {
                            if content.contains(pattern) {
                                println!("{}", content);
                            }
                        }
                        Err(e) => eprintln!("Error reading line: {}", e),
                    }
                }
            }
            Err(e) => eprintln!("Failed to open {}: {}", file, e),
        }
    }
}

fn order(arguments: Vec<String>) {
    let mut reverse = false;
    let files:Vec<String>; 

    if !arguments.is_empty() && arguments[0] == "-r" {
        reverse = true;
        files = arguments[1..].to_vec();
    } else {
        files = arguments;
    }

    let mut all_lines:Vec<String> = Vec::new();

    for file in files {
        match File::open(&file) {
            Ok(f) => {
                let reader = io::BufReader::new(f);
                for line in reader.lines() {
                    match line {
                        Ok(content) => all_lines.push(content),
                        Err(e) => eprintln!("Error reading line: {}", e),
                    }
                }
            }
            Err(e) => eprintln!("Failed to open {}: {}", file, e),
        }
    }

    if reverse {
        all_lines.sort_by(|a ,b| b.cmp(a))
    } else {
        all_lines.sort();
    }

    for line in all_lines {
        println!("{}", line);
    }
}