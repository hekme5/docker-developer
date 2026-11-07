#!/usr/bin/env python3
"""
Python GUI Demo (Tkinter)
Run this script inside the Ubuntu GUI container to test Python GUI support.
Command: python3 python_gui_demo.py
"""

import sys
import os
import platform
import tkinter as tk
from tkinter import ttk, messagebox

class PythonGuiApp:
    def __init__(self, root):
        self.root = root
        self.root.title("Python GUI Demo - Ubuntu Desktop")
        self.root.geometry("520x420")
        self.root.minsize(450, 350)

        # Style configuration
        style = ttk.Style()
        style.theme_use('clam')

        # Header Frame
        header = ttk.Frame(root, padding=15)
        header.pack(fill=tk.X)

        title_label = ttk.Label(
            header,
            text="Python GUI (Tkinter) is Working!",
            font=("Helvetica", 16, "bold"),
            foreground="#1976D2"
        )
        title_label.pack(anchor=tk.W)

        sub_label = ttk.Label(
            header,
            text=f"Python {platform.python_version()} on {platform.system()} ({platform.machine()})",
            font=("Helvetica", 10)
        )
        sub_label.pack(anchor=tk.W, pady=(4, 0))

        # Separator
        ttk.Separator(root, orient='horizontal').pack(fill=tk.X, padx=15)

        # Content Frame
        content = ttk.Frame(root, padding=15)
        content.pack(fill=tk.BOTH, expand=True)

        # Counter Section
        self.counter = 0
        counter_frame = ttk.LabelFrame(content, text="Interactive Test", padding=10)
        counter_frame.pack(fill=tk.X, pady=(0, 10))

        self.counter_label = ttk.Label(
            counter_frame,
            text=f"Button Click Count: {self.counter}",
            font=("Helvetica", 12)
        )
        self.counter_label.pack(side=tk.LEFT, padx=10)

        btn_click = ttk.Button(counter_frame, text="Click Me!", command=self.on_click)
        btn_click.pack(side=tk.RIGHT, padx=5)

        btn_reset = ttk.Button(counter_frame, text="Reset", command=self.on_reset)
        btn_reset.pack(side=tk.RIGHT, padx=5)

        # System Information Box
        info_frame = ttk.LabelFrame(content, text="Environment Info", padding=10)
        info_frame.pack(fill=tk.BOTH, expand=True)

        info_text = (
            f"Executable: {sys.executable}\n"
            f"User: {os.environ.get('USER', 'unknown')}\n"
            f"DISPLAY: {os.environ.get('DISPLAY', 'unknown')}\n"
            f"Working Dir: {os.getcwd()}\n"
        )

        label_info = ttk.Label(info_frame, text=info_text, justify=tk.LEFT, font=("Courier", 10))
        label_info.pack(anchor=tk.W, fill=tk.BOTH)

        # Footer Actions
        footer = ttk.Frame(root, padding=10)
        footer.pack(fill=tk.X)

        btn_msg = ttk.Button(footer, text="Show Alert Dialog", command=self.show_dialog)
        btn_msg.pack(side=tk.LEFT)

        btn_quit = ttk.Button(footer, text="Exit", command=root.destroy)
        btn_quit.pack(side=tk.RIGHT)

    def on_click(self):
        self.counter += 1
        self.counter_label.config(text=f"Button Click Count: {self.counter}")

    def on_reset(self):
        self.counter = 0
        self.counter_label.config(text=f"Button Click Count: {self.counter}")

    def show_dialog(self):
        messagebox.showinfo(
            "Tkinter Dialog",
            "Tkinter GUI popups work properly in this Ubuntu container!"
        )

def main():
    root = tk.Tk()
    app = PythonGuiApp(root)
    root.mainloop()

if __name__ == "__main__":
    main()

