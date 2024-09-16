import tkinter as tk
from tkinter import PhotoImage
import subprocess
import sys
import os

# Function to run the command in the terminal
def run_command(command, *args):
    subprocess.run([command] + list(args), shell=True)

# Function to show the main page
def show_main_page():
    for widget in root.winfo_children():
        widget.destroy()
    root.geometry("400x300")  # Reset the window size for the main page

    # Determine the path to the image file
    if hasattr(sys, '_MEIPASS'):
        bg_image_path = os.path.join(sys._MEIPASS, "bg.png")
    else:
        bg_image_path = "bg.png"

    # Load the background image
    bg_image = PhotoImage(file=bg_image_path)

    # Create a canvas and set the background image
    canvas = tk.Canvas(root, width=400, height=300)
    canvas.pack(fill="both", expand=True)
    canvas.create_image(0, 0, image=bg_image, anchor="nw")

    # Add menu buttons on top of the canvas
    canvas.create_window(200, 50, window=tk.Button(root, text="Super Create", command=show_super_create_page))
    canvas.create_window(200, 100, window=tk.Button(root, text="Super Start", command=show_super_start_page))
    canvas.create_window(200, 150, window=tk.Button(root, text="Super Stop", command=show_super_stop_page))
    canvas.create_window(200, 200, window=tk.Button(root, text="Super Delete", command=show_super_delete_page))

    # Keep a reference to the image to prevent garbage collection
    root.bg_image = bg_image

# Function to show the Super Create page
def show_super_create_page():
    for widget in root.winfo_children():
        widget.destroy()
    root.geometry("400x400")  # Set the window size to 400x400 for the Super Create page
    tk.Label(root, text="Super Create VM").pack(padx=10, pady=5)
    tk.Label(root, text="Name:").pack(padx=10, pady=5)
    global name_entry
    name_entry = tk.Entry(root)
    name_entry.pack(padx=10, pady=5)
    tk.Label(root, text="RAM:").pack(padx=10, pady=5)
    global ram_entry
    ram_entry = tk.Entry(root)
    ram_entry.pack(padx=10, pady=5)
    tk.Label(root, text="Disk Size:").pack(padx=10, pady=5)
    global disk_entry
    disk_entry = tk.Entry(root)
    disk_entry.pack(padx=10, pady=5)
    tk.Label(root, text="Number:").pack(padx=10, pady=5)
    global number_entry
    number_entry = tk.Entry(root)
    number_entry.pack(padx=10, pady=5)
    tk.Button(root, text="Create", command=lambda: run_command("genVM.bat", "SC", name_entry.get(), number_entry.get(), ram_entry.get(), disk_entry.get()), bg="green").pack(padx=10, pady=20)
    tk.Button(root, text="Back", command=show_main_page, bg="red").pack(padx=10, pady=5)

# Function to show the Super Start page
def show_super_start_page():
    for widget in root.winfo_children():
        widget.destroy()
    root.geometry("400x300")  # Reset the window size for other pages
    tk.Label(root, text="Super Start VM").pack(padx=10, pady=5)
    tk.Label(root, text="Name:").pack(padx=10, pady=5)
    global name_entry
    name_entry = tk.Entry(root)
    name_entry.pack(padx=10, pady=5)
    tk.Label(root, text="Number:").pack(padx=10, pady=5)
    global number_entry
    number_entry = tk.Entry(root)
    number_entry.pack(padx=10, pady=5)
    tk.Button(root, text="Start", command=lambda: run_command("genVM.bat", "SD", name_entry.get(), number_entry.get()), bg="green").pack(padx=10, pady=20)
    tk.Button(root, text="Back", command=show_main_page, bg="red").pack(padx=10, pady=5)

# Function to show the Super Stop page
def show_super_stop_page():
    for widget in root.winfo_children():
        widget.destroy()
    root.geometry("400x300")  # Reset the window size for other pages
    tk.Label(root, text="Super Stop VM").pack(padx=10, pady=5)
    tk.Label(root, text="Name:").pack(padx=10, pady=5)
    global name_entry
    name_entry = tk.Entry(root)
    name_entry.pack(padx=10, pady=5)
    tk.Label(root, text="Number:").pack(padx=10, pady=5)
    global number_entry
    number_entry = tk.Entry(root)
    number_entry.pack(padx=10, pady=5)
    tk.Button(root, text="Stop", command=lambda: run_command("genVM.bat", "SA", name_entry.get(), number_entry.get()), bg="green").pack(padx=10, pady=20)
    tk.Button(root, text="Back", command=show_main_page, bg="red").pack(padx=10, pady=5)

# Function to show the Super Delete page
def show_super_delete_page():
    for widget in root.winfo_children():
        widget.destroy()
    root.geometry("400x300")  # Reset the window size for other pages
    tk.Label(root, text="Super Delete VM").pack(padx=10, pady=5)
    tk.Label(root, text="Name:").pack(padx=10, pady=5)
    global name_entry
    name_entry = tk.Entry(root)
    name_entry.pack(padx=10, pady=5)
    tk.Label(root, text="Number:").pack(padx=10, pady=5)
    global number_entry
    number_entry = tk.Entry(root)
    number_entry.pack(padx=10, pady=5)
    tk.Button(root, text="Delete", command=lambda: run_command("genVM.bat", "SS", name_entry.get(), number_entry.get()), bg="green").pack(padx=10, pady=20)
    tk.Button(root, text="Back", command=show_main_page, bg="red").pack(padx=10, pady=5)

# Function to create the main page
def create_main_page():
    menu = tk.Menu(root)
    root.config(menu=menu)
    menu.add_command(label="Super Create", command=show_super_create_page)
    menu.add_command(label="Super Start", command=show_super_start_page)
    menu.add_command(label="Super Stop", command=show_super_stop_page)
    menu.add_command(label="Super Delete", command=show_super_delete_page)

# Create the main application window
root = tk.Tk()
root.title("VM Configuration")
root.geometry("400x300")  # Set the window size to 400x300

# Show the main page initially
show_main_page()

root.mainloop()