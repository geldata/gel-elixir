defmodule Tests.Gel.Protocol.Codecs.MultiRangeTest do
  use Tests.Support.GelCase

  skip_before(version: 4, scope: :module)

  @input_ranges %{
    "multirange<int32>" => [
      Gel.MultiRange.new([Gel.Range.new(1, 2)]),
      Gel.MultiRange.new([Gel.Range.new(1, 2), Gel.Range.new(3, 4)]),
      {Gel.MultiRange.new([Gel.Range.empty()]), Gel.MultiRange.new()}
    ]
  }

  setup :gel_client

  for {type, values} <- @input_ranges do
    for value <- values do
      {input, output} =
        case value do
          {input, output} ->
            {input, output}

          value ->
            {value, value}
        end

      test "encoding #{inspect(input)} as #{inspect(type)} with expecting #{inspect(output)} as the result",
           %{client: client} do
        type = unquote(type)
        input = unquote(Macro.escape(input))
        output = unquote(Macro.escape(output))
        assert ^output = Gel.query_single!(client, "select <#{type}>$0", [input])
      end
    end
  end
end
