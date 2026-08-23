from kitty.boss import Boss
from kittens.tui.handler import result_handler


def main(args):
    pass


def toggle_term(boss: Boss):
    tab = boss.active_tab

    if tab is None:
        return

    all_other_windows = tab.all_window_ids_except_active_window

    #
    # First invocation:
    # create the bottom terminal if it doesn't exist yet.
    #
    if len(all_other_windows) == 0:
        new_window_id = boss.launch(
            "--cwd=current",
            "--location=hsplit",
            "--bias",
            "30",
        )

        if new_window_id:
            boss.call_remote_control(
                tab.id,
                [
                    "resize_window",
                    "--match",
                    f"id:{new_window_id}",
                    "--axis",
                    "vertical",
                    "--increment",
                    "-10",
                ],
            )

        return

    #
    # Toggle visibility using layouts.
    #
    if tab.current_layout.name == "stack":
        tab.goto_layout("splits")
    else:
        tab.goto_layout("stack")


@result_handler(no_ui=True)
def handle_result(args, result, target_window_id, boss: Boss):
    if boss.window_id_map.get(target_window_id):
        toggle_term(boss)
