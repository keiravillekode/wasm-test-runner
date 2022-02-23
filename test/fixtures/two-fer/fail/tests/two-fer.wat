(module
  (memory (export "mem") 1)

  (data $greeting (i32.const 0) "One for you, one for me.")
 
  (func (export "twoFer") (param $offset i32) (param $length i32) (result i32 i32)
    (return (i32.const 0) (i32.const 24))
  )
)
