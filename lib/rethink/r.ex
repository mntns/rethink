defmodule Rethink.R do

  def make_array(a), do: [2, a]
  # TODO: do some research regarding make_object

  # * Compound types
  def var(number), do: [10, [number]]
  
  def javascript(string), do: [11, [string]]

  def uuid, do: [169]

  def http(string), do: [153, [string]]
  def error(string), do: [12, [string]]

  def implicit_var, do: [13]

  # * Data Operators
  def db(string),    do: [14, [string]]
  def table(string), do: [15, [string]]

  def get(string),     do: [16, [string]]
  def get_all(string), do: [17, [string]]

  # Simple DATUM Ops
  ops = [[:eq, 17], [:ne, 18], [:lt, 19],
         [:le, 20], [:gt, 21], [:ge, 22], 
         [:not, 23], [:add, 24], [:sub, 25],
         [:mul, 26], [:div, 27], [:mod, 28]]

  # Thanks, l3kn!
  for [name, code] <- ops do
    def unquote(name)(a),      do: [unquote(code), a]
    def unquote(name)(d1, d2), do: [unquote(code), [d1, d2]]
  end

  # DATUM Array Ops
  def append(array, datum),     do: [29, make_array(array), datum]
  def prepend(array, datum),    do: [80, make_array(array), datum]
  def difference(array, array), do: [95, make_array(array), make_array(array)]

  # DATUM Set Ops
  def set_insert(array, datum),       do: [88, [make_array(array), datum]]
  def set_intersection(array, datum), do: [89, [make_array(array), datum]]
  def set_union(array, array),        do: [90, [make_array(array), make_array(array)]]
  def set_difference(array, array),   do: [91, [make_array(array), make_array(array)]]

  def slice(s, number1, number2), do: [30, [s, number1, number2]]
  def skip(s, number)           , do: [70, [s, number]]
  def limit(s, number)          , do: [71, [s, number]]
  def indexes_of(sequence, datum)      , do: [87, [sequence, datum]]
  def contains(sequence, datum)        , do: [93, [sequence, datum]]

  # * Type Ops
  def coerce_to(top, string), do: [51, [top, string]]
  def type_of(top),           do: [52, [top]]

  # * Write Ops
  #def update(selection, function, opts) when is_function(function), do: [53, [selection, ]]
  #def update(selection, object, opts \\ nil), do:
  #def delete(selection, opts),     do
    #def replace(selection)

  def insert(table, object),       do: [56, [table, object]]
  def insert(table, object, opts), do: [56, [table, object], opts]

  # Administrative OPs
  def db_create(string), do: [57, [string]]
  def db_drop(string),   do: [58, [string]]
  def db_list,           do: [59]
  
  def table_create(string), do: [60, [string]]
  def table_drop(string),   do: [61, [string]]
  def table_list,           do: [62]

  # * Secondary indexes OPs
  # TODO: check this {multi:BOOL} thingie
  def index_create(table, string),           do: [75, [table, string]]
  def index_create(table, string, function), do: [75, [table, string, function]]
  def index_drop(table, string),             do: [76, [table, string]]
  def index_list(table),                     do: [77, [table]]

  def index_status(table, strings),          do: [139, [table, [make_array(strings)]]]
  def index_wait(table, strings),            do: [140, [table, [make_array(strings)]]]
  def index_rename(table, string1, string2), do: [156, [table, string1, string2]]

  # * Control Operators
  #def funcall
  #def branch
  #def all
  #def for_each

  def func(f) when is_function(f) do
    {_, arity} = :erlang.fun_info(f, :arity)
    args = :lists.seq(1, arity)
    vars = Enum.map(args, &(var(&1)))
    [69, [make_array(args), apply(f, vars)]]
  end

  # TODO: ASC
  # TODO: DESC

  def info(top), do: [79, [top]]

  # def match(string, string)

  def upcase(string),   do: [141, [string]]
  def downcase(string), do: [142, [string]]

  def sample(sequence, number), do: [81, [sequence, number]]

end
