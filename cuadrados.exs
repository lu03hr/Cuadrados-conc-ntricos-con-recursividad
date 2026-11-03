defmodule Cuadrados do
  @lado 400
  @margen 20

  def generar(archivo_salida, cantidad, reduccion) do
    tamano = @lado + 2 * @margen

    cuadrados = dibujar(@margen, @margen, @lado, cantidad, reduccion)

    svg = """
    <svg xmlns="http://www.w3.org/2000/svg"
         width="#{tamano}" height="#{tamano}"
         viewBox="0 0 #{tamano} #{tamano}">
      <rect width="100%" height="100%" fill="white"/>
    #{cuadrados}</svg>
    """

    File.write!(archivo_salida, svg)
    IO.puts("Imagen creada: #{archivo_salida}")
  end

  defp dibujar(_x, _y, lado, faltan, _reduccion) when faltan <= 0 or lado <= 0, do: ""

  defp dibujar(x, y, lado, faltan, reduccion) do
    actual = dibujar_cuadrado(x, y, lado, faltan)

    siguiente_lado = lado - reduccion
    desplazamiento = reduccion / 2

    actual <>
      dibujar(x + desplazamiento, y + desplazamiento, siguiente_lado, faltan - 1, reduccion)
  end

  defp dibujar_cuadrado(x, y, lado, faltan) do
    color =
      case rem(faltan, 3) do
        0 -> "#fff7e6"
        1 -> "#f7c8d3"
        _ -> "#b46a72"
      end

    """
      <rect x="#{x}" y="#{y}"
            width="#{lado}" height="#{lado}"
            fill="#{color}" stroke="#dddddd"
            stroke-width="0.5"/>
    """
  end
end

{cantidad, reduccion} =
  case System.argv() do
    [c, r | _] -> {String.to_integer(c), String.to_integer(r)}
    _ -> {10, 30}
  end

Cuadrados.generar("cuadrados.svg", cantidad, reduccion)
