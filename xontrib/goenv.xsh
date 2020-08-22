"""Initialize goenv at xonsh start
"""
import builtins

__all__ = ()

GOENV = $(which goenv).strip()


def create_alias(output):
    commands = []
    for line in [l for l in output.split('\n') if 'shell' in l]:
        commands += line.strip()[:-1].split('|')

    def goenv(args):
        if args and len(args):
            cmd = args[0]
            arguments = args[1:]
        else:
            cmd = None
            arguments = []

        if cmd in commands:
            source-bash --suppress-skip-message $(@(GOENV) sh-@(cmd) @(arguments))
        else:
            @(GOENV) @(args)

    builtins.aliases['goenv'] = goenv


# check if goenv installed
if GOENV:
    GOENV_ENV = $(@(GOENV) init -)

    # init goenv
    source-bash --suppress-skip-message @(GOENV_ENV) e>/dev/null
    create_alias(GOENV_ENV)
