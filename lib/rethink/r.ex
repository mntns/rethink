defmodule Rethink.R do
  @moduledoc false

  def make_array(a), do: [2, a]
  # TODO: do some research regarding make_object

  # * Compound types
  def var(number), do: [10, [number]]

  def javascript(string),       do: [11, [string]]
  def javascript(string, opts), do: [11, [string], opts]

  def uuid, do: [169]

  def http(string)      , do: [153, [string]]
  def http(string, opts), do: [153, [string], opts]

  def error(string), do: [12, [string]]

  def implicit_var, do: [13]

  # * Data Operators
  def db(string),    do: [14, [string]]

  def table(string),       do: [15, [string]]
  def table(string, opts), do: [15, [string], opts]

  def get(table, string),           do: [16, [table, string]]

  def get_all(table, datum),        do: [78, [table, datum]]
  def get_all(table, datum, opts),  do: [78, [table, datum], opts]

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
  def append(array, datum),       do: [29, [array, datum]]
  def prepend(array, datum),      do: [80, [array, datum]]
  def difference(array1, array2), do: [95, [array1, make_array(array2)]]

  # DATUM Set Ops
  def set_insert(array, datum),       do: [88, [array, datum]]

  def set_intersection(array1, array2), do: [89, [array1, make_array(array2)]]
  def set_union(array1, array2),        do: [90, [array1, make_array(array2)]]
  def set_difference(array1, array2),   do: [91, [array1, make_array(array2)]]

  def slice(sequence, number1, number2), do: [30, [sequence, number1, number2]]
  def skip(sequence, number),            do: [70, [sequence, number]]
  def limit(sequence, number),           do: [71, [sequence, number]]
  def indexes_of(sequence, datum)      , do: [87, [sequence, datum]]
  def contains(sequence, datum)        , do: [93, [sequence, datum]]

  # Stream/Object Ops
  def get_field(object, string),     do: [31, [make_array(object), string]]
  def keys(object),                  do: [94, object]

  def has_fields(object, pathspec),  do: [32, [object, pathspec]]
  def with_fields(object, pathspec), do: [96, [object, pathspec]]
  def pluck(object, pathspec),       do: [33, [object, pathspec]]
  def without(object, pathspec),     do: [34, [object, pathspec]]
  def merge(objects),                do: [35, make_array(objects)]

  # Sequence Ops
  def between(selection, datum1, datum2), do: [36, [make_array(selection), datum1, datum2]]
  def reduce(sequence, function),         do: [37, [make_array(sequence), func(function)]]
  def map(sequence, function),            do: [38, [make_array(sequence), func(function)]]

  def filter(sequence, function) when is_function(function), do: [39, [sequence, func(function)]]  
  def filter(sequence, object),                              do: [39, [sequence, object]]

  def concat_map(sequence, function), do: [40, [sequence, func(function)]]
  # TODO: order_by
  def distinct(sequence), do: [42, [sequence]]

  def count(sequence), do: [43, [sequence]]
  def is_empty(sequence), do: [86, [sequence]]
  def union(sequences), do: [44, [sequences]]
  
  def nth(sequence, number), do: [45, [sequence, number]]
  
  def bracket(sequence, number) when is_integer(number), do: [170, [sequence, number]]
  def bracket(sequence, string),                         do: [170, [sequence, string]]

  def inner_join(sequence1, sequence2, function), do: [48, [sequence1, sequence2, func(function)]]
  def outer_join(sequence1, sequence2, function), do: [48, [sequence1, sequence2, func(function)]]

  # TODO: eq_join
  def zip(sequence), do: [72, [sequence]]

  def range(),                 do: [173]
  def range(number),           do: [173, [number]]
  def range(number1, number2), do: [173, [number1. number2]]

  # Array Ops
  def insert_at(array, number, datum),    do: [82, [array, number, datum]]
  def delete_at(array, number),           do: [83, [array, number]]
  def delete_at(array, number1, number2), do: [83, [array, number1, number2]]
  def change_at(array, number, datum),    do: [84, [array, number, datum]]
  def splice_at(array1, number, array2),  do: [85, [array1, number, array2]]

  # * Type Ops
  def coerce_to(top, string), do: [51, [top, string]]
  def type_of(top),           do: [52, [top]]

  # * Write Ops
  #def update(selection, function, opts) when is_function(function), do: [53, [selection, ]]
  #def update(selection, object, opts \\ nil), do:
  #def delete(selection, opts)
  ##def replace(selection)

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

  def asc,  do: [73]
  def desc, do: [74]

  def info(top),               do: [79, [top]]
  def match(string1, string2), do: [97, [string1, string2]]

  def upcase(string),   do: [141, [string]]
  def downcase(string), do: [142, [string]]

  def sample(sequence, number), do: [81, [sequence, number]]
  def default(top1, top2),      do: [92, [top1, top2]]

  def json(string),          do: [98, string]
  def to_json_string(datum), do: [172, datum]

  def iso8601(string),     do: [99, string]
  def to_iso8601(time),    do: [100, time]
  def epoch_time(number),  do: [101, number]
  def to_epoch_time(time), do: [102, time]

  def now(),                       do: [103]
  def in_timezone(time, string),   do: [104, [time, string]]
  def during(time1, time2, time3), do: [105, [time1, time2, time3]]
  def date(time),                  do: [106, time]

  def time_of_day(time),           do: [126, time]
  def timezone(time),              do: [127, time]


  time_accessors = [[:year, 128], [:month, 129], [:day, 130],
    [:day_of_week, 131], [:day_of_year, 132], [:hours, 133],
    [:minutes, 134], [:seconds, 135]]

  for [name, code] <- time_accessors do
    def unquote(name)(time), do: [unquote(code), time]
  end

  def time(number1, number2, number3, string) do
    [136, [number1, number2, number3, string]]
  end

  def time(number1, number2, number3, number4, number5, number6, string) do
    [136, [number1, number2, number3, number4, number5, number6, string]]
  end

  constants = [[:monday, 107], [:tuesday, 108], [:wednesday, 109],
    [:thursday, 110], [:friday, 111], [:saturday, 112],
    [:sunday, 113], [:january, 114], [:february, 115],
    [:march, 116], [:april, 117], [:may, 118],
    [:june, 119], [:july, 120], [:august, 121],
    [:september, 122], [:october, 123], [:november, 124],
    [:december, 125]]

  for [name, code] <- constants do
    def unquote(name)(), do: unquote(code)
  end

  def literal(json), do: [137, json]

  # Aggregations
  aggregations = [[:group, 144], [:sum, 145], [:avg, 146],
    [:min, 147], [:max, 148]]

  for [name, code] <- aggregations do
    def unquote(name)(sequence, string), do: [unquote(code), [make_array(sequence), string]]
  end

  # Misc
  def split(string),            do: [149, string]
  def ungroup(data),            do: [150, data]  
  def random(number1, number2), do: [151, [number1, number2]]
  def changes(table),           do: [152, table]
  def args(array),              do: [154, make_array(array)]

  # TODO: BINARY

  # Geospatial queries
  def geojson(object),                   do: [157, object]
  def to_geojson(geometry),              do: [158, geometry] 
  def point(n1, n2),                     do: [159, [n1, n2]]
  def line(array),                       do: [160, make_array(array)]
  def polygon(array),                    do: [161, make_array(array)]
  def distance(geometry1, geometry2),    do: [162, [geometry1, geometry2]]
  def intersects(geometry1, geometry2),  do: [163, [geometry1, geometry2]]
  def includes(geometry1, geometry2),    do: [164, [geometry1, geometry2]]
  def circle(geometry, number),          do: [165, [geometry, number]]
  def get_intersecting(table, geometry), do: [166, [table, geometry]]
  def fill(geometry),                    do: [167, geometry] 
  def get_nearest(table, geometry),      do: [168, [table, geometry]]
  def polygon_sub(geometry1, geometry2), do: [171, [geometry1, geometry2]]      


  def run(query) do
    Rethink.Connection.run(query)
  end
  end
