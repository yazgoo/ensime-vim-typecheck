if !has('nvim')
    execute 'pyfile' expand('<sfile>:p').'.py'
endif

function! ensime_vim_type_check#log(message) abort
    return s:call_plugin('log', [a:message])
endfunction

function! ensime_vim_type_check#my_handler(ctx, payload) abort
    return s:call_plugin('my_handler', [a:ctx, a:payload])
endfunction

function! ensime_vim_type_check#my_check(args, range) abort
    return s:call_plugin('my_check', [a:args, a:range])
endfunction

function! s:call_plugin(method_name, args) abort
    " TODO: support nvim rpc
    if has('nvim')
      throw 'Call rplugin from vimscript: not supported yet'
    endif
    unlet! g:__error
    python <<PY
try:
  r = getattr(ensime_vim_type_check_plugin, vim.eval('a:method_name'))(*vim.eval('a:args'))
  vim.command('let g:__result = ' + json.dumps(([] if r == None else r)))
except:
  vim.command('let g:__error = ' + json.dumps(str(sys.exc_info()[0]) + ':' + str(sys.exc_info()[1])))
PY
    if exists('g:__error')
      throw g:__error
    endif
    let res = g:__result
    unlet g:__result
    return res
endfunction
