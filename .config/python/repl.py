from prompt_toolkit import PromptSession
from prompt_toolkit.history import FileHistory
from prompt_toolkit.auto_suggest import AutoSuggestFromHistory
from prompt_toolkit.lexers import PygmentsLexer
from pygments.lexers.python import PythonLexer
from prompt_toolkit.key_binding import KeyBindings
from prompt_toolkit.key_binding.bindings.named_commands import get_by_name
from prompt_toolkit.filters import has_focus
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.search import start_search


def start_custom_repl(history_path: str):
    # Key bindings for history search
    kb = KeyBindings()

    @kb.add(Keys.ControlR)  # This binds Ctrl-R
    def _(event):
        start_search(event.app.current_buffer)
        # event.app.current_buffer.start_history_search_backward()
        # get_by_name('start-reverse-search')(event)

    session: PromptSession = PromptSession(
        history=FileHistory(history_path),
        auto_suggest=AutoSuggestFromHistory(),
        lexer=PygmentsLexer(PythonLexer),
        key_bindings=kb,
    )

    while True:
        try:
            # Get input
            text = session.prompt("🐍>> ", lexer=PygmentsLexer(PythonLexer))
            # Evaluate and execute the command
            exec(text, globals(), locals())
        except KeyboardInterrupt:
            continue
        except EOFError:
            raise SystemExit  # Exit Python session on Ctrl-D
        except Exception as e:
            # Handle execution errors
            print(f"Error: {e}")


if __name__ == "__main__":
    history_file = "<path-to-your-custom-history-file>"
    start_custom_repl(history_file)
