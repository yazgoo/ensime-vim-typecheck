function! MyCheck() abort
python <<PY
def log(message):
    f = open("/tmp/ensime_typecheck", "a")
    f.write(message + "\n")
    f.close()
    None
try:
    def my_handler(ctx, payload):
        log("handler called with {}".format(payload))
        if payload["typehint"] == "NewScalaNotesEvent":
            log("MyCheck received note")
            ctx.message("MyCheck received note")
    ensime_plugin.on_receive("mycheck", my_handler)
    log("intialized callback")
    log("sending TypecheckFilesReq")
    ensime_plugin.send_request(
        {"typehint": "TypecheckFilesReq",
            "files" : [vim.eval("expand('%:p')")]})
except Exception, e:
    log(e.message)
PY
endfunction
command! -nargs=0 MyCheck call MyCheck()
