#!/usr/bin/env python3
# daily todos for waybar, one file per day in ~/.local/share/todo
# open todos move to today
import datetime
import html
import json
import os
import subprocess
import sys
from pathlib import Path

folder = Path(os.environ.get("XDG_DATA_HOME", Path.home() / ".local/share")) / "todo"
today = datetime.date.today()
one_day = datetime.timedelta(days=1)
OPEN = "[ ] "
DONE = "[x] "
FONT = "JetBrainsMono Nerd Font"
# rofi exit codes for kb-custom-1 and 2
PREVIOUS_DAY = 10
NEXT_DAY = 11
# left/right change the day, so ctrl+b/f move the cursor
DAY_KEYS = (
    "-kb-move-char-back", "Control+b",
    "-kb-move-char-forward", "Control+f",
    "-kb-custom-1", "Left",
    "-kb-custom-2", "Right",
)


def file(day):
    return folder / f"{day}.txt"


def load(day):
    if not file(day).exists():
        return []
    lines = [line.strip() for line in file(day).read_text().splitlines() if line.strip()]
    # lines from the editor may have no box
    return [line if line.startswith((OPEN, DONE)) else OPEN + line for line in lines]


def save(day, items):
    folder.mkdir(parents=True, exist_ok=True)
    file(day).write_text("".join(f"{item}\n" for item in items))


def carry_over():
    for path in sorted(folder.glob("????-??-??.txt")):
        day = datetime.date.fromisoformat(path.stem)
        items = load(day)
        open_items = [item for item in items if item.startswith(OPEN)]
        if day < today and open_items:
            save(today, load(today) + open_items)
            save(day, [item for item in items if item not in open_items])


def text_of(item):
    return item[len(OPEN):]


def box(item):
    return "󰄲" if item.startswith(DONE) else "󰄱"


def row(item):
    return f"{box(item)} {text_of(item)}"


# the tooltip does not use the nerd font
def tooltip_row(item):
    return f"<span font_family='{FONT}'>{box(item)}</span> {html.escape(text_of(item), quote=False)}"


def label(day):
    return "Today" if day == today else f"{day:%a %d %b}"


# signal 9 in the waybar config
def refresh():
    subprocess.run(["pkill", "-RTMIN+9", "-x", "waybar"])


def bar():
    carry_over()
    items = load(today)
    open_count = sum(item.startswith(OPEN) for item in items)
    print(json.dumps({
        "text": f"󰄲 {open_count}" if open_count else "󰄲",
        "tooltip": "\n".join(tooltip_row(item) for item in items) or "Nothing to do",
        "class": "pending" if open_count else "empty",
    }, ensure_ascii=False))


# returns row, typed text and exit code, None on escape
def ask(prompt, hint, rows, selected=0, text="", keys=()):
    command = [
        "rofi", "-dmenu", "-i", "-p", prompt,
        "-format", "i|f",
        "-selected-row", str(selected),
        "-filter", text,
        "-font", f"{FONT} 12",
        # one click instead of two
        "-me-select-entry", "", "-me-accept-entry", "MousePrimary",
        *keys,
        "-theme-str", f'entry {{ placeholder: "{hint}"; }}',
    ]
    rofi = subprocess.run(command, input="\n".join(rows), capture_output=True, text=True)
    if rofi.returncode not in (0, PREVIOUS_DAY, NEXT_DAY):
        return None
    index, _, typed = rofi.stdout.rstrip("\n").partition("|")
    return int(index), typed.strip(), rofi.returncode


# returns the clicked row, None if there is none
def pick(prompt, hint, rows):
    answer = ask(prompt, hint, rows)
    if answer is None or answer[0] < 0:
        return None
    return answer[0]


def menu():
    day = today
    selected = 0
    draft = ""
    while True:
        carry_over()
        items = load(day)
        rows = [row(item) for item in items]
        count = len(items)
        extra_rows = [f"< {label(day - one_day)}", f"{label(day + one_day)} >", "Edit", "Delete"]
        answer = ask(label(day), "Type to add, click to tick", rows + extra_rows, selected, draft, DAY_KEYS)
        if answer is None:
            return
        index, typed, code = answer
        # keep typed text when the day changes
        draft = typed if code else ""
        if code:
            day += one_day if code == NEXT_DAY else -one_day
            selected = 0
            continue
        if typed:
            items.append(OPEN + typed)
            selected = count
        elif index == count:
            day -= one_day
            selected = 0
            continue
        elif index == count + 1:
            day += one_day
            selected = 0
            continue
        elif index == count + 2:
            picked = pick("Edit", "Click the one to edit", rows)
            if picked is None:
                continue
            # rofi quits without rows, the text hides the blank one
            answer = ask("Edit", "New text", [" "], text=text_of(items[picked]))
            if answer is None or not answer[1]:
                continue
            items[picked] = items[picked][:len(OPEN)] + answer[1]
            selected = picked
        elif index == count + 3:
            picked = pick("Delete", "Click the one to delete", rows)
            if picked is None:
                continue
            del items[picked]
            selected = 0
        elif index >= 0:
            items[index] = (OPEN if items[index].startswith(DONE) else DONE) + text_of(items[index])
            selected = index
        else:
            return
        save(day, items)
        refresh()


def edit():
    save(today, load(today))
    subprocess.run(["alacritty", "-e", os.environ.get("EDITOR", "nano"), str(file(today))])
    refresh()


commands = {"bar": bar, "menu": menu, "edit": edit}
commands[sys.argv[1]]()
