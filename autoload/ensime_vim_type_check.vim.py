import vim
class EnsimeVimTypeCheck:
    def log(self, message):
        f = open("/tmp/ensime_typecheck", "a")
        f.write(message + "\n")
        f.close()
        None
    def my_handler(self, ctx, payload):
        self.log("handler called with {}".format(payload))
        if payload["typehint"] == "NewScalaNotesEvent":
            self.log("MyCheck received note")
            ctx.message("MyCheck received note")
    def my_check(self):
        try:
            ensime_plugin.on_receive("mycheck", self.my_handler)
            self.log("intialized callback")
            self.log("sending TypecheckFilesReq")
            ensime_plugin.send_request(
                {"typehint": "TypecheckFilesReq",
                    "files" : [vim.eval("expand('%:p')")]})
        except Exception, e:
            self.log(e.message)
ensime_vim_type_check_plugin = EnsimeVimTypeCheck(vim)
