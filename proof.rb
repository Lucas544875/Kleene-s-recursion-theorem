require 'base64'

def gen_args(inputs, offset = 0)
  inputs.each_with_index.inject("") do |sum, (x,i)|
    sum + "x#{offset+i+1}=#{x}"
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
