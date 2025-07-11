use std::fs;
use std::thread;
use std::time::Duration;

fn main() {
    // Loop until we get a valid initial reading.
    let mut prev_stat = loop {
        match parse_cpu_stat() {
            Ok(stat) => break stat,
            Err(e) => {
                // Report the error and wait before retrying.
                eprintln!("Initial CPU stat read failed: {}. Retrying...", e);
                thread::sleep(Duration::from_millis(1000));
            }
        }
    };

    loop {
        thread::sleep(Duration::from_millis(1000));

        // Check each result individually to provide specific error messages.
        let cpu_result = parse_cpu_stat();
        let temp_result = get_temp();
        let mem_result = get_memory();

        // Only proceed if all results are Ok.
        if let (Ok(curr_stat), Ok(temp), Ok(memory)) = (&cpu_result, &temp_result, &mem_result) {
            let usage = get_usage(prev_stat, *curr_stat);
            let mem_usage: f32 = 100.0 * (1.0 - (memory.0 as f32) / (memory.1 as f32));
            println!("{usage} {temp} {mem_usage}");
            prev_stat = *curr_stat;
        } else {
            // If any result was an Err, print a message to stderr.
            // This makes the error visible without crashing the program.
            if let Err(e) = cpu_result {
                eprintln!("Error parsing CPU stat: {}", e);
            }
            if let Err(e) = temp_result {
                eprintln!("Error getting temperature: {}", e);
            }
            if let Err(e) = mem_result {
                eprintln!("Error getting memory info: {}", e);
            }
        }
    }
}

fn get_usage(prev: (u32, u32), curr: (u32, u32)) -> f32 {
    let delta_idle = (curr.0 - prev.0) as f32;
    let delta_total = (curr.1 - prev.1) as f32;
    if delta_total == 0.0 {
        return 0.0;
    }
    100.0 * (1.0 - delta_idle / delta_total)
}

fn parse_cpu_stat() -> Result<(u32, u32), Box<dyn std::error::Error>> {
    let info = fs::read_to_string("/proc/stat")?;
    let cpu_line = info
        .lines()
        .next()
        .ok_or("Could not read first line of /proc/stat")?;
    let mut idle_time = 0;
    let mut total_time = 0;
    for (i, stat_str) in cpu_line.split_whitespace().skip(1).enumerate() {
        if let Ok(stat) = stat_str.parse::<u32>() {
            if i == 3 || i == 4 {
                idle_time += stat;
            }
            total_time += stat;
        }
    }
    Ok((idle_time, total_time))
}

fn get_temp() -> Result<u32, Box<dyn std::error::Error>> {
    let temp_str = fs::read_to_string("/sys/class/hwmon/hwmon2/temp1_input")?;
    let temp = temp_str.trim().parse::<u32>()?;
    Ok(temp)
}

fn get_memory() -> Result<(u64, u64), Box<dyn std::error::Error>> {
    let mem_str = fs::read_to_string("/proc/meminfo")?;
    let mut mem_total: u64 = 0;
    let mut mem_available: u64 = 0;
    for line in mem_str.lines() {
        if let Some(value_str) = line.strip_prefix("MemTotal:") {
            if let Some(value) = value_str.trim().strip_suffix(" kB") {
                mem_total = value.parse::<u64>()?;
            }
            continue;
        }
        if let Some(value_str) = line.strip_prefix("MemAvailable:") {
            if let Some(value) = value_str.trim().strip_suffix(" kB") {
                mem_available = value.parse::<u64>()?;
            }
            break;
        }
    }
    if mem_total == 0 || mem_available == 0 {
        Err("Could not parse MemTotal or MemAvailable from /proc/meminfo".into())
    } else {
        Ok((mem_available, mem_total))
    }
}
