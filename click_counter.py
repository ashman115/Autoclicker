import tkinter as tk
from tkinter import messagebox

class ClickCounterApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Click Counter")
        
        # Initialize the click count
        self.click_count = 0
        
        # Label for instructions
        self.instruction_label = tk.Label(root, text="Click the button as many times as you can in 5 seconds!")
        self.instruction_label.pack(pady=20)
        
        # Combined button that both starts the timer and counts clicks
        self.click_button = tk.Button(root, text="Start", command=self.start_or_click)
        self.click_button.pack(pady=10)
        
        # Label to show the countdown
        self.timer_label = tk.Label(root, text="Time Left: 5", font=("Arial", 14))
        self.timer_label.pack(pady=20)
        
        # Track if the timer is running
        self.timer_running = False
        self.time_left = 5  # Time in seconds
    
    def start_or_click(self):
        if not self.timer_running:
            # Start the timer and reset the click count
            self.click_count = 0
            self.time_left = 5
            self.update_timer()
            self.timer_running = True
            self.click_button.config(text="Click Me!", state=tk.NORMAL)  # Change button text to "Click Me!"
        else:
            # Increment the click count if the timer is running
            self.click_count += 1
    
    def update_timer(self):
        if self.time_left > 0:
            self.timer_label.config(text=f"Time Left: {self.time_left}")
            self.time_left -= 1
            self.root.after(1000, self.update_timer)  # Update every second
        else:
            self.timer_label.config(text="Time's up!")
            self.click_button.config(state=tk.DISABLED)  # Disable the button
            messagebox.showinfo("Game Over", f"You clicked the button {self.click_count} times!")
            
            # Calculate CPS (Clicks per Second)
            cps = self.click_count / 5.0  # CPS is clicks divided by 5 seconds
            print(f"Total Clicks: {self.click_count}")
            print(f"Clicks Per Second (CPS): {cps:.2f}")  # Print CPS to command line with 2 decimal places
            self.timer_running = False
    
# Create the main window
root = tk.Tk()
app = ClickCounterApp(root)

# Run the application
root.mainloop()
