defmodule Rfx.Edit.Credo.MultiAlias2 do
  @moduledoc """
  This code was lifted from @doorgan's "MultiAlias" notebook that he published
  after the release of Sourceror 0.6.0.
  """

  @behaviour Rfx.Edit

  @impl true
  def edit(source) do
    source
    |> Sourceror.parse_string!()
    |> expand_aliases()
    |> Sourceror.to_string()
  end

  def expand_aliases(quoted) do
    Sourceror.postwalk(quoted, fn
      {:alias, _, [{{:., _, [left, :{}]}, _, right}]}, state ->
        {_, _, base} = left

        aliases =
          Enum.map(right, fn {_, _, segments} ->
            aliased = {:__aliases__, [], base ++ segments}
            {:alias, [], [aliased]}
          end)

        {{:__block__, [], aliases}, state}

      quoted, state ->
        {quoted, state}
    end)
  end

end
