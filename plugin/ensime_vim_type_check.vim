if has('nvim')
  finish
endif
augroup ensime_vim_type_check
    autocmd!
augroup END

command! -nargs=0 -range MyCheck call ensime_vim_type_check#my_check([<f-args>], '')

