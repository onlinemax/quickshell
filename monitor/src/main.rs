use std::fs;
use std::thread;
use std::time::Duration;
fn main() {
    let mut prev_stat = parse_cpu_stat();
    loop {
        thread::sleep(Duration::from_millis(1000));
        let curr_stat = parse_cpu_stat();
        let usage = get_usage(prev_stat, curr_stat);
        let temp = get_temp();
        let memory = get_memory();
        let mem_usage: f32 = 100.0 * (1.0 - (memory.0 as f32) / (memory.1 as f32));
        println!("{usage} {temp} {mem_usage}");
        prev_stat = curr_stat;
    }
}
fn get_usage(prev: (u32, u32), curr: (u32, u32)) -> f32 {
    let delta_idle = (curr.0 - prev.0) as f32;
    let delta_total = (curr.1 - prev.1) as f32;
    return 100.0 * (1.0 - delta_idle / delta_total);
}

fn parse_cpu_stat() -> (u32, u32) {
    let stat_filename = "/proc/stat";
    let info = fs::read_to_string(stat_filename).expect("The file /proc/stat doesn't exist");
    let cpu_line = &info.lines().next().unwrap()[5..];
    let mut idle_time = 0;
    let mut total_time = 0;
    for (i, stat_str) in cpu_line.split(" ").enumerate() {
        let stat = str::parse::<u32>(stat_str);

        if stat.is_err() {
            continue;
        }

        let stat = stat.unwrap(); // impossible to be bad
        if i == 3 || i == 4 {
            idle_time += stat
        }

        total_time += stat;
    }
    return (idle_time, total_time);
}
fn get_temp() -> u32 {
    let temp_file = "/sys/class/hwmon/hwmon2/temp1_input";
    match fs::read_to_string(temp_file) {
        Ok(temp_str) => str::parse::<u32>(temp_str.trim()).unwrap(),
        Err(_) => {
            eprintln!(
                "You have to change the file to the correct temperature each linux computer have a different file"
            );
            0
        }
    }
}
fn get_memory() -> (u64, u64) {
    let mem_file = "/proc/meminfo";
    let mem_str = fs::read_to_string(mem_file).expect("The file /proc/meminfo doesn't exist");
    let mut mem_total: u64 = 0;
    let mut mem_available: u64 = 0;
    for line in mem_str.lines() {
        if line.starts_with("MemTotal") {
            let start = line.find(":").unwrap();
            let end = line.find("k").unwrap(); // Assuming in KB
            mem_total = str::parse(&line[(start + 1)..end].trim()).unwrap();
            continue;
        }
        if line.starts_with("MemAvailable") {
            let start = line.find(":").unwrap();
            let end = line.find("k").unwrap(); // Assuming in KB
            mem_available = str::parse(&line[(start + 1)..end].trim()).unwrap();
            break; // MemAvailable should be after MemTotal
        }
    }
    return (mem_available, mem_total);
}
