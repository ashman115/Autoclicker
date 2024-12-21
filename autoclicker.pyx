from pynput.mouse import Controller, Button
import time
import keyboard
import threading
import os  # Import os for more forceful termination

# Variables
click_interval = 0.0000000000000000000000000000000000001  # Interval between clicks (1ms for practical use)
running_time = 480  # Run for 8 minutes
delay_start_time = 5  # Delay start by 5 seconds
clicks_count = 0  # Counter for clicks
stop_flag = False  # Flag to stop clicking
start_flag = False  # Flag to start clicking

# Mouse controller
mouse = Controller()

# Function to click repeatedly
def click_mouse():
    global clicks_count
    start_time = time.perf_counter()  # Initialize start_time
    while not stop_flag:
        if start_flag:  # Only click once start_flag is set
            current_time = time.perf_counter()  # Update current_time every loop
            if current_time - start_time >= click_interval:  # Ensure accurate timing
                mouse.click(Button.right)  # Simulate a left-click
                clicks_count += 1  # Increment click counter
                start_time = current_time  # Reset the start time for next interval
        time.sleep(0.0000000000000000000000000000000000001)  # Small sleep to prevent overloading the CPU

# Function to calculate CPS (clicks per second)
def calculate_cps():
    global clicks_count
    last_time = time.perf_counter()  # High precision timing
    while not stop_flag:
        time.sleep(1)  # Update CPS every second
        current_time = time.perf_counter()
        elapsed = current_time - last_time
        last_time = current_time
        print(f"CPS: {clicks_count / elapsed:.2f}")
        clicks_count = 0  # Reset the click counter for the next second

# Function to listen for the E-STOP (press "H" to stop)
def listen_for_stop():
    global stop_flag
    print("Press 'H' to stop the autoclicker.")
    while not stop_flag:
        if keyboard.is_pressed('h'):  # Check if the 'H' key is pressed
            stop_flag = True  # Set the flag to stop the clicking thread
            print("E-STOP activated! Stopping autoclicker...")
            os._exit(0)  # Immediately exit after E-Stop is triggered
        time.sleep(0.0000000000000000000000000000000000001)  # Avoid overloading the CPU with constant checks

# Main function to control the autoclicker process
def main():
    global start_flag, stop_flag

    # Start listening for the E-STOP in a separate thread
    stop_thread = threading.Thread(target=listen_for_stop)
    stop_thread.daemon = True  # Set as a daemon thread to exit with the program
    stop_thread.start()

    # Start clicking thread
    click_thread = threading.Thread(target=click_mouse)
    click_thread.daemon = True  # Set as a daemon thread to exit with the program
    click_thread.start()

    # Start CPS calculation thread
    cps_thread = threading.Thread(target=calculate_cps)
    cps_thread.daemon = True  # Set as a daemon thread to exit with the program
    cps_thread.start()

    # Wait for the delayed start
    print(f"Starting in {delay_start_time} seconds...")
    time.sleep(delay_start_time)  # Delay the start of the autoclicker

    # Set the start flag to allow clicking to begin
    start_flag = True

    # Wait for running time and stop
    time.sleep(running_time)
    stop_flag = True
    print("Timer expired. Stopping autoclicker...")

    # Exit immediately to return to the command prompt
    os._exit(0)  # Forcefully exit after running time expires

# Ensure this block calls main() when executed directly
if __name__ == "__main__":
    main()
