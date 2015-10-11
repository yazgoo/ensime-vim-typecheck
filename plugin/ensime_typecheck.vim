function! MyCheck() abort
    python <<PY
    ensime_plugin.send_request(
        {"typehint": "TypecheckFilesReq",
            "files" : [vim.eval("expand('%:p')")})
PY
endfunction
command! -nargs=* -range MyCheck call MyCheck([<f-args>], '')
python <<PY
def my_handler(payload):
    if payload["typehint"] == "NewScalaNotesEvent":
        vim.message("MyCheck result: " + payload["notes"]["msg"])
ensime_plugin.on_receive(my_handler)
PY

