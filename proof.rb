require 'base64'

def gen_args(inputs, offset = 0)
  if offset == 0
    "X = " + inputs.to_s
  else
    "X[#{offset-1},#{inputs.length}] = " + inputs.to_s
  end
end

def universal(gedel,inputs)
  prog = Base64.decode64(gedel)
  args = gen_args(inputs)
  eval(args + prog)
end

def smn(m, gedel, inputs)
  prog = Base64.decode64(gedel)
  args = gen_args(inputs, m)
  Base64.strict_encode(args + prog)
end

def fix(gedel, n)
  prog = Base64.decode64(gedel)
  f = << ~EOS
  x#{n} = smn(n, x#{n}, [x#{n}])
  #{prog}
  EOS
  d = Base64.strict_encode(f)
  smn(n, d, d)
end

def h(x,y)
  return universal(universal(y,x),'')
end

