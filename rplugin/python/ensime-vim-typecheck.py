import neovim
@neovim.plugin
class EnsimeVimTypeCheck:
    def log(self, message):
        f = open("/tmp/ensime_typecheck", "a")
        f.write(message + "\n")
        f.close()
        None
    def __init__(self, vim):
        self.vim = vim
    def my_handler(self, ctx, payload):
        self.log("handler called with {}".format(payload))
        if payload["typehint"] == "NewScalaNotesEvent":
            for note in payload["notes"]:
                self.log("MyCheck received note")
                ctx.message("MyCheck: note line {}".format(note["line"]))
    @neovim.command('MyCheck', range='', nargs='0', sync=True)
    def my_check(self, args, range = None):
        try:
            ensime_plugin.on_receive("mycheck", self.my_handler)
            self.log("intialized callback")
            self.log("sending TypecheckFilesReq")
            ensime_plugin.send_request(
                {"typehint": "TypecheckFilesReq",
                    "files" : [self.vim.eval("expand('%:p')")]})
        except Exception, e:
            self.log(e.message)
