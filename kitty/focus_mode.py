from kittens.tui.handler import result_handler


def main(args):
    pass


def find_bottom_terminal(tab):
    tab_id = str(tab.id)

    for window in tab.windows:
        user_vars = getattr(window, "user_vars", {})

        if user_vars.get("bottom_terminal") == tab_id:
            return window

    return None


def create_bottom_terminal(boss, tab):
    return boss.launch(
        "--var",
        f"bottom_terminal={tab.id}",
        "--cwd=current",
        "--location=hsplit",
        "--bias",
        "30",
    )


def toggle_focus_mode(boss):
    tab = boss.active_tab

    if tab is None:
        return

    terminal = find_bottom_terminal(tab)

    #
    # First use: create the dev terminal
    #
    if terminal is None:
        create_bottom_terminal(boss, tab)
        return

    #
    # Existing terminal:
    # toggle focus mode
    #
    if tab.current_layout.name == "stack":
        tab.goto_layout("splits")
    else:
        tab.goto_layout("stack")


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss):
    if boss.window_id_map.get(target_window_id):
        toggle_focus_mode(boss)
