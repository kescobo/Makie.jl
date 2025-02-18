default_theme(scene) = generic_plot_attributes!(Attributes())


"""
### Generic attributes

- `visible::Bool = true` sets whether the plot will be rendered or not.
- `overdraw::Bool = false` sets whether the plot will draw over other plots. This specifically means ignoring depth checks in GL backends.
- `transparency::Bool = false` adjusts how the plot deals with transparency. In GLMakie `transparency = true` results in using Order Independent Transparency.
- `fxaa::Bool = true` adjusts whether the plot is rendered with fxaa (anti-aliasing).
- `inspectable::Bool = true` sets whether this plot should be seen by `DataInspector`.
- `depth_shift::Float32 = 0f0` adjusts the depth value of a plot after all other transformations, i.e. in clip space, where `0 <= depth <= 1`. This only applies to GLMakie and WGLMakie and can be used to adjust render order (like a tunable overdraw).
- `model::Makie.Mat4f` sets a model matrix for the plot. This replaces adjustments made with `translate!`, `rotate!` and `scale!`.
- `space::Symbol = :data` sets the transformation space for box encompassing the volume plot. See `Makie.spaces()` for possible inputs.
- `clip_planes::Vector{Plane3f} = Plane3f[]`: allows you to specify up to 8 planes behind which plot objects get clipped (i.e. become invisible). By default clip planes are inherited from the parent plot or scene.
"""
function generic_plot_attributes!(attr)
    attr[:transformation] = automatic
    attr[:model] = automatic
    attr[:visible] = true
    attr[:transparency] = false
    attr[:overdraw] = false
    attr[:ssao] = false
    attr[:inspectable] = true
    attr[:depth_shift] = 0.0f0
    attr[:space] = :data
    attr[:inspector_label] = automatic
    attr[:inspector_clear] = automatic
    attr[:inspector_hover] = automatic
    attr[:clip_planes] = automatic
    return attr
end

function generic_plot_attributes(attr)
    return (
        transformation = attr[:transformation],
        model = attr[:model],
        visible = attr[:visible],
        transparency = attr[:transparency],
        overdraw = attr[:overdraw],
        ssao = attr[:ssao],
        inspectable = attr[:inspectable],
        depth_shift = attr[:depth_shift],
        space = attr[:space],
        inspector_label = attr[:inspector_label],
        inspector_clear = attr[:inspector_clear],
        inspector_hover = attr[:inspector_hover],
        clip_planes =  attr[:clip_planes]

    )
end

function mixin_generic_plot_attributes()
    @DocumentedAttributes begin
        transformation = automatic
        "Sets a model matrix for the plot. This overrides adjustments made with `translate!`, `rotate!` and `scale!`."
        model = automatic
        "Controls whether the plot will be rendered or not."
        visible = true
        "Adjusts how the plot deals with transparency. In GLMakie `transparency = true` results in using Order Independent Transparency."
        transparency = false
        "Controls if the plot will draw over other plots. This specifically means ignoring depth checks in GL backends"
        overdraw = false
        "Adjusts whether the plot is rendered with ssao (screen space ambient occlusion). Note that this only makes sense in 3D plots and is only applicable with `fxaa = true`."
        ssao = false
        "sets whether this plot should be seen by `DataInspector`."
        inspectable = true
        "adjusts the depth value of a plot after all other transformations, i.e. in clip space, where `0 <= depth <= 1`. This only applies to GLMakie and WGLMakie and can be used to adjust render order (like a tunable overdraw)."
        depth_shift = 0.0f0
        "sets the transformation space for box encompassing the plot. See `Makie.spaces()` for possible inputs."
        space = :data
        "adjusts whether the plot is rendered with fxaa (anti-aliasing, GLMakie only)."
        fxaa = true
        "Sets a callback function `(plot, index, position) -> string` which replaces the default label generated by DataInspector."
        inspector_label = automatic
        "Sets a callback function `(inspector, plot) -> ...` for cleaning up custom indicators in DataInspector."
        inspector_clear = automatic
        "Sets a callback function `(inspector, plot, index) -> ...` which replaces the default `show_data` methods."
        inspector_hover = automatic
        """
        Clip planes offer a way to do clipping in 3D space. You can set a Vector of up to 8 `Plane3f` planes here,
        behind which plots will be clipped (i.e. become invisible). By default clip planes are inherited from the
        parent plot or scene. You can remove parent `clip_planes` by passing `Plane3f[]`.
        """
        clip_planes = automatic
    end
end

"""
### Color attributes

- `colormap::Union{Symbol, Vector{<:Colorant}} = :viridis` sets the colormap that is sampled for numeric `color`s.
  `PlotUtils.cgrad(...)`, `Makie.Reverse(any_colormap)` can be used as well, or any symbol from ColorBrewer or PlotUtils.
  To see all available color gradients, you can call `Makie.available_gradients()`.
- `colorscale::Function = identity` color transform function. Can be any function, but only works well together with `Colorbar` for `identity`, `log`, `log2`, `log10`, `sqrt`, `logit`, `Makie.pseudolog10` and `Makie.Symlog10`.
- `colorrange::Tuple{<:Real, <:Real}` sets the values representing the start and end points of `colormap`.
- `nan_color::Union{Symbol, <:Colorant} = RGBAf(0,0,0,0)` sets a replacement color for `color = NaN`.
- `lowclip::Union{Nothing, Symbol, <:Colorant} = nothing` sets a color for any value below the colorrange.
- `highclip::Union{Nothing, Symbol, <:Colorant} = nothing` sets a color for any value above the colorrange.
- `alpha = 1.0` sets the alpha value of the colormap or color attribute. Multiple alphas like in `plot(alpha=0.2, color=(:red, 0.5)`, will get multiplied.
"""
function colormap_attributes!(attr, colormap)
    attr[:colormap] = colormap
    attr[:colorscale] = identity
    attr[:colorrange] = automatic
    attr[:lowclip] = automatic
    attr[:highclip] = automatic
    attr[:nan_color] = :transparent
    attr[:alpha] = 1.0
    return attr
end

function colormap_attributes(attr)
    return (
        colormap = attr[:colormap],
        colorscale = attr[:colorscale],
        colorrange = attr[:colorrange],
        lowclip = attr[:lowclip],
        highclip = attr[:highclip],
        nan_color = attr[:nan_color],
        alpha = attr[:alpha]
    )
end

function mixin_colormap_attributes()
    @DocumentedAttributes begin
        """
        Sets the colormap that is sampled for numeric `color`s.
        `PlotUtils.cgrad(...)`, `Makie.Reverse(any_colormap)` can be used as well, or any symbol from ColorBrewer or PlotUtils.
        To see all available color gradients, you can call `Makie.available_gradients()`.
        """
        colormap = @inherit colormap :viridis
        """
        The color transform function. Can be any function, but only works well together with `Colorbar` for `identity`, `log`, `log2`, `log10`, `sqrt`, `logit`, `Makie.pseudolog10` and `Makie.Symlog10`.
        """
        colorscale = identity
        "The values representing the start and end points of `colormap`."
        colorrange = automatic
        "The color for any value below the colorrange."
        lowclip = automatic
        "The color for any value above the colorrange."
        highclip = automatic
        "The color for NaN values."
        nan_color = :transparent
        "The alpha value of the colormap or color attribute. Multiple alphas like in `plot(alpha=0.2, color=(:red, 0.5)`, will get multiplied."
        alpha = 1.0
    end
end

"""
### 3D shading attributes

- `shading = Makie.automatic` sets the lighting algorithm used. Options are `NoShading` (no lighting), `FastShading` (AmbientLight + PointLight) or `MultiLightShading` (Multiple lights, GLMakie only). Note that this does not affect RPRMakie.
- `diffuse::Vec3f = Vec3f(1.0)` sets how strongly the red, green and blue channel react to diffuse (scattered) light.
- `specular::Vec3f = Vec3f(0.4)` sets how strongly the object reflects light in the red, green and blue channels.
- `shininess::Real = 32.0` sets how sharp the reflection is.
- `backlight::Float32 = 0f0` sets a weight for secondary light calculation with inverted normals.
- `ssao::Bool = false` adjusts whether the plot is rendered with ssao (screen space ambient occlusion). Note that this only makes sense in 3D plots and is only applicable with `fxaa = true`.
"""
function shading_attributes!(attr)
    attr[:shading] = automatic
    attr[:diffuse] = 1.0
    attr[:specular] = 0.2
    attr[:shininess] = 32.0f0
    attr[:backlight] = 0f0
    attr[:ssao] = false
end

function shading_attributes(attr)
    return (
        shading = attr[:shading],
        diffuse = attr[:diffuse],
        specular = attr[:specular],
        shininess = attr[:shininess],
        backlight = attr[:backlight],
        ssao = attr[:ssao]
    )
end

function mixin_shading_attributes()
    @DocumentedAttributes begin
        "Sets the lighting algorithm used. Options are `NoShading` (no lighting), `FastShading` (AmbientLight + PointLight) or `MultiLightShading` (Multiple lights, GLMakie only). Note that this does not affect RPRMakie."
        shading = automatic
        "Sets how strongly the red, green and blue channel react to diffuse (scattered) light."
        diffuse = 1.0
        "Sets how strongly the object reflects light in the red, green and blue channels."
        specular = 0.2
        "Sets how sharp the reflection is."
        shininess = 32.0f0
        "Sets a weight for secondary light calculation with inverted normals."
        backlight = 0f0
        "RPRMakie only attribute to set complex RadeonProRender materials.
        *Warning*, how to set an RPR material may change and other backends will ignore this attribute"
        material = nothing
    end
end

"""
    `calculated_attributes!(trait::Type{<: AbstractPlot}, plot)`
trait version of calculated_attributes
"""
calculated_attributes!(trait, plot) = nothing

"""
    `calculated_attributes!(plot::AbstractPlot)`
Fill in values that can only be calculated when we have all other attributes filled
"""
calculated_attributes!(plot::T) where T = calculated_attributes!(T, plot)

"""
    image(x, y, image)
    image(image)

Plots an image on a rectangle bounded by `x` and `y` (defaults to size of image).
"""
@recipe Image (
        x::EndPoints,
        y::EndPoints,
        image::AbstractMatrix{<:Union{FloatType,Colorant}}) begin
    "Sets whether colors should be interpolated between pixels."
    interpolate = true
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
    fxaa = false
    """
    Sets a transform for uv coordinates, which controls how the image is mapped to its rectangular area.
    The attribute can be `I`, `scale::VecTypes{2}`, `(translation::VecTypes{2}, scale::VecTypes{2})`,
    any of :rotr90, :rotl90, :rot180, :swap_xy/:transpose, :flip_x, :flip_y, :flip_xy, or most
    generally a `Makie.Mat{2, 3, Float32}` or `Makie.Mat3f` as returned by `Makie.uv_transform()`.
    They can also be changed by passing a tuple `(op3, op2, op1)`.
    """
    uv_transform = automatic
    colormap = [:black, :white]
end

"""
    heatmap(x, y, matrix)
    heatmap(x, y, func)
    heatmap(matrix)
    heatmap(xvector, yvector, zvector)

Plots a heatmap as a collection of rectangles.
`x` and `y` can either be of length `i` and `j` where
`(i, j)` is `size(matrix)`, in this case the rectangles will be placed
around these grid points like voronoi cells. Note that
for irregularly spaced `x` and `y`, the points specified by them
are not centered within the resulting rectangles.

`x` and `y` can also be of length `i+1` and `j+1`, in this case they
are interpreted as the edges of the rectangles.

Colors of the rectangles are derived from `matrix[i, j]`.
The third argument may also be a `Function` (i, j) -> v which is then evaluated over the
grid spanned by `x` and `y`.

Another allowed form is using three vectors `xvector`, `yvector` and `zvector`.
In this case it is assumed that no pair of elements `x` and `y` exists twice.
Pairs that are missing from the resulting grid will be treated as if `zvector` had a `NaN`
    element at that position.

If `x` and `y` are omitted with a matrix argument, they default to `x, y = axes(matrix)`.

Note that `heatmap` is slower to render than `image` so `image` should be preferred for large, regularly spaced grids.
"""
@recipe Heatmap (x::Union{EndPoints,RealVector, RealMatrix},
                 y::Union{EndPoints,RealVector, RealMatrix},
                 values::AbstractMatrix{<:Union{FloatType,Colorant}}) begin
    "Sets whether colors should be interpolated"
    interpolate = false
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
end

"""
    volume(volume_data)
    volume(x, y, z, volume_data)

Plots a volume with optional physical dimensions `x, y, z`.

All volume plots are derived from casting rays for each drawn pixel. These rays
intersect with the volume data to derive some color, usually based on the given
colormap. How exactly the color is derived depends on the algorithm used.
"""
@recipe Volume (
        x::EndPoints,
        y::EndPoints,
        z::EndPoints,
        # TODO: consider using RGB{N0f8}, RGBA{N0f8} instead of Vec/RGB(A){Float32}
        volume::AbstractArray{<: Union{Float32, Vec3f, RGB{Float32}, Vec4f, RGBA{Float32}}, 3}
    ) begin
    """
    Sets the volume algorithm that is used. Available algorithms are:
    * `:iso`: Shows an isovalue surface within the given float data. For this only samples within `isovalue - isorange .. isovalue + isorange` are included in the final color of a pixel.
    * `:absorption`: Accumulates color based on the float values sampled from volume data. At each ray step (starting from the front) a value is sampled from the volume data and then used to sample the colormap. The resulting color is weighted by the ray step size and blended the previously accumulated color. The weight of each step can be adjusted with the multiplicative `absorption` attribute.
    * `:mip`: Shows the maximum intensity projection of the given float data. This derives the color of a pixel from the largest value sampled from the respective ray.
    * `:absorptionrgba`: This algorithm matches :absorption, but samples colors directly from RGBA volume data. For each ray step a color is sampled from the data, weighted by the ray step size and blended with the previously accumulated color. Also considers `absorption`.
    * `:additive`: Accumulates colors using `accumulated_color = 1 - (1 - accumulated_color) * (1 - sampled_color)` where `sampled_color` is a sample of volume data at the current ray step.
    * `:indexedabsorption`: This algorithm acts the same as :absorption, but interprets the volume data as indices. They are used as direct indices to the colormap. Also considers `absorption`.
    """
    algorithm = :mip
    "Sets the target value for the :iso algorithm. `accepted = isovalue - isorange < value < isovalue + isorange`"
    isovalue = 0.5
    "Sets the maximum accepted distance from the isovalue for the :iso algorithm. `accepted = isovalue - isorange < value < isovalue + isorange`"
    isorange = 0.05
    "Sets whether the volume data should be sampled with interpolation."
    interpolate = true
    "Enables depth write for :iso so that volume correctly occludes other objects."
    enable_depth = true
    "Absorption multiplier for algorithm = :absorption, :absorptionrgba and :indexedabsorption. This changes how much light each voxel absorbs."
    absorption = 1f0
    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...
end

const VecOrMat{T} = Union{AbstractVector{T}, AbstractMatrix{T}}

"""
    surface(x, y, z)
    surface(z)

Plots a surface, where `(x, y)` define a grid whose heights are the entries in `z`.
`x` and `y` may be `Vectors` which define a regular grid, **or** `Matrices` which define an irregular grid.
"""
@recipe Surface (x::VecOrMat{<:FloatType}, y::VecOrMat{<:FloatType}, z::VecOrMat{<:FloatType}) begin
    "Can be set to an `Matrix{<: Union{Number, Colorant}}` to color surface independent of the `z` component. If `color=nothing`, it defaults to `color=z`. Can also be a `Makie.AbstractPattern`."
    color = nothing
    "Inverts the normals generated for the surface. This can be useful to illuminate the other side of the surface."
    invert_normals = false
    "[(W)GLMakie only] Specifies whether the surface matrix gets sampled with interpolation."
    interpolate = true
    """
    Sets a transform for uv coordinates, which controls how a texture is mapped to a surface.
    The attribute can be `I`, `scale::VecTypes{2}`, `(translation::VecTypes{2}, scale::VecTypes{2})`,
    any of :rotr90, :rotl90, :rot180, :swap_xy/:transpose, :flip_x, :flip_y, :flip_xy, or most
    generally a `Makie.Mat{2, 3, Float32}` or `Makie.Mat3f` as returned by `Makie.uv_transform()`.
    They can also be changed by passing a tuple `(op3, op2, op1)`.
    """
    uv_transform = automatic
    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...
end

"""
    lines(positions)
    lines(x, y)
    lines(x, y, z)

Creates a connected line plot for each element in `(x, y, z)`, `(x, y)` or `positions`.

`NaN` values are displayed as gaps in the line.
"""
@recipe Lines (positions,) begin
    "The color of the line."
    color = @inherit linecolor
    "Sets the width of the line in screen units"
    linewidth = @inherit linewidth
    """
    Sets the dash pattern of the line. Options are `:solid` (equivalent to `nothing`), `:dot`, `:dash`, `:dashdot` and `:dashdotdot`.
    These can also be given in a tuple with a gap style modifier, either `:normal`, `:dense` or `:loose`.
    For example, `(:dot, :loose)` or `(:dashdot, :dense)`.

    For custom patterns have a look at [`Makie.Linestyle`](@ref).
    """
    linestyle = nothing
    """
    Sets the type of line cap used. Options are `:butt` (flat without extrusion),
    `:square` (flat with half a linewidth extrusion) or `:round`.
    """
    linecap = @inherit linecap
    """
    Controls the rendering at corners. Options are `:miter` for sharp corners,
    `:bevel` for "cut off" corners, and `:round` for rounded corners. If the corner angle
    is below `miter_limit`, `:miter` is equivalent to `:bevel` to avoid long spikes.
    """
    joinstyle = @inherit joinstyle
    "Sets the minimum inner join angle below which miter joins truncate. See also `Makie.miter_distance_to_angle`."
    miter_limit = @inherit miter_limit
    "Sets which attributes to cycle when creating multiple plots."
    cycle = [:color]
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
    fxaa = false
end

"""
    linesegments(positions)
    linesegments(vector_of_2tuples_of_points)
    linesegments(x, y)
    linesegments(x, y, z)

Plots a line for each pair of points in `(x, y, z)`, `(x, y)`, or `positions`.
"""
@recipe LineSegments (positions,) begin
    "The color of the line."
    color = @inherit linecolor
    "Sets the width of the line in pixel units"
    linewidth = @inherit linewidth
    """
    Sets the dash pattern of the line. Options are `:solid` (equivalent to `nothing`), `:dot`, `:dash`, `:dashdot` and `:dashdotdot`.
    These can also be given in a tuple with a gap style modifier, either `:normal`, `:dense` or `:loose`.
    For example, `(:dot, :loose)` or `(:dashdot, :dense)`.

    For custom patterns have a look at [`Makie.Linestyle`](@ref).
    """
    linestyle = nothing
    "Sets the type of linecap used, i.e. :butt (flat with no extrusion), :square (flat with 1 linewidth extrusion) or :round."
    linecap = @inherit linecap
    "Sets which attributes to cycle when creating multiple plots."
    cycle = [:color]
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
    fxaa = false
end

# alternatively, mesh3d? Or having only mesh instead of poly + mesh and figure out 2d/3d via dispatch
"""
    mesh(x, y, z)
    mesh(mesh_object)
    mesh(x, y, z, faces)
    mesh(xyz, faces)

Plots a 3D or 2D mesh. Supported `mesh_object`s include `Mesh` types from [GeometryBasics.jl](https://github.com/JuliaGeometry/GeometryBasics.jl).
"""
@recipe Mesh (mesh::Union{AbstractVector{<:GeometryBasics.Mesh},GeometryBasics.Mesh,GeometryBasics.MetaMesh},) begin
    """
    Sets the color of the mesh. Can be a `Vector{<:Colorant}` for per vertex colors or a single `Colorant`.
    A `Matrix{<:Colorant}` can be used to color the mesh with a texture, which requires the mesh to contain
    texture coordinates. A `<: AbstractPattern` can be used to apply a repeated, pixel sampled pattern to
    the mesh, e.g. for hatching.
    """
    color = @inherit patchcolor
    "sets whether colors should be interpolated"
    interpolate = true
    cycle = [:color => :patchcolor]
    matcap = nothing
    """
    Sets a transform for uv coordinates, which controls how a texture is mapped to a mesh.
    The attribute can be `I`, `scale::VecTypes{2}`, `(translation::VecTypes{2}, scale::VecTypes{2})`,
    any of :rotr90, :rotl90, :rot180, :swap_xy/:transpose, :flip_x, :flip_y, :flip_xy, or most
    generally a `Makie.Mat{2, 3, Float32}` or `Makie.Mat3f` as returned by `Makie.uv_transform()`.
    They can also be changed by passing a tuple `(op3, op2, op1)`.
    """
    uv_transform = automatic
    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...
end

"""
    scatter(positions)
    scatter(x, y)
    scatter(x, y, z)

Plots a marker for each element in `(x, y, z)`, `(x, y)`, or `positions`.
"""
@recipe Scatter (positions,) begin
    "Sets the color of the marker. If no color is set, multiple calls to `scatter!` will cycle through the axis color palette."
    color = @inherit markercolor
    "Sets the scatter marker."
    marker = @inherit marker
    """
    Sets the size of the marker by scaling it relative to its base size which can differ for each marker.
    A `Real` scales x and y dimensions by the same amount.
    A `Vec` or `Tuple` with two elements scales x and y separately.
    An array of either scales each marker separately.
    Humans perceive the area of a marker as its size which grows quadratically with `markersize`,
    so multiplying `markersize` by 2 results in a marker that is 4 times as large, visually.
    """
    markersize = @inherit markersize
    "Sets the color of the outline around a marker."
    strokecolor = @inherit markerstrokecolor
    "Sets the width of the outline around a marker."
    strokewidth = @inherit markerstrokewidth
    "Sets the color of the glow effect around the marker."
    glowcolor = (:black, 0.0)
    "Sets the size of a glow effect around the marker."
    glowwidth = 0.0

    "Sets the rotation of the marker. A `Billboard` rotation is always around the depth axis."
    rotation = Billboard()
    "The offset of the marker from the given position in `markerspace` units. An offset of 0 corresponds to a centered marker."
    marker_offset = Vec3f(0)
    "Controls whether the model matrix (without translation) applies to the marker itself, rather than just the positions. (If this is true, `scale!` and `rotate!` will affect the marker."
    transform_marker = false
    "Optional distancefield used for e.g. font and bezier path rendering. Will get set automatically."
    distancefield = nothing
    uv_offset_width = (0.0, 0.0, 0.0, 0.0)
    "Sets the space in which `markersize` is given. See `Makie.spaces()` for possible inputs"
    markerspace = :pixel
    "Sets which attributes to cycle when creating multiple plots"
    cycle = [:color]
    "Enables depth-sorting of markers which can improve border artifacts. Currently supported in GLMakie only."
    depthsorting = false
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
    fxaa = false
end

function deprecated_attributes(::Type{<:Scatter})
    (
        (; attribute = :rotations, message = "`rotations` has been renamed to `rotation` for consistency in Makie v0.21.", error = true),
    )
end

"""
    meshscatter(positions)
    meshscatter(x, y)
    meshscatter(x, y, z)

Plots a mesh for each element in `(x, y, z)`, `(x, y)`, or `positions` (similar to `scatter`).
`markersize` is a scaling applied to the primitive passed as `marker`.
"""
@recipe MeshScatter (positions,) begin
    "Sets the color of the marker."
    color = @inherit markercolor
    "Sets the scattered mesh."
    marker = :Sphere
    "Sets the scale of the mesh. This can be given as a `Vector` to apply to each scattered mesh individually."
    markersize = 0.1
    "Sets the rotation of the mesh. A numeric rotation is around the z-axis, a `Vec3f` causes the mesh to rotate such that the the z-axis is now that vector, and a quaternion describes a general rotation. This can be given as a Vector to apply to each scattered mesh individually."
    rotation = 0.0
    cycle = [:color]
    """
    Sets a transform for uv coordinates, which controls how a texture is mapped to the scattered mesh.
    Note that the mesh needs to include uv coordinates for this, which is not the case by default
    for geometry primitives. You can use `GeometryBasics.uv_normal_mesh(prim)` with, for example `prim = Rect2f(0, 0, 1, 1)`.
    The attribute can be `I`, `scale::VecTypes{2}`, `(translation::VecTypes{2}, scale::VecTypes{2})`,
    any of :rotr90, :rotl90, :rot180, :swap_xy/:transpose, :flip_x, :flip_y, :flip_xy, or most
    generally a `Makie.Mat{2, 3, Float32}` or `Makie.Mat3f` as returned by `Makie.uv_transform()`.
    It can also be set per scattered mesh by passing a `Vector` of any of the above and operations
    can be changed by passing a tuple `(op3, op2, op1)`.
    """
    uv_transform = automatic
    "Controls whether the (complete) model matrix applies to the scattered mesh, rather than just the positions. (If this is true, `scale!`, `rotate!` and `translate!()` will affect the scattered mesh.)"
    transform_marker = false
    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...
end

function deprecated_attributes(::Type{<:MeshScatter})
    (
        (; attribute = :rotations, message = "`rotations` has been renamed to `rotation` for consistency in Makie v0.21.", error = true),
    )
end

"""
    text(positions; text, kwargs...)
    text(x, y; text, kwargs...)
    text(x, y, z; text, kwargs...)

Plots one or multiple texts passed via the `text` keyword.
`Text` uses the `PointBased` conversion trait.
"""
@recipe Text (positions,) begin
    "Specifies one piece of text or a vector of texts to show, where the number has to match the number of positions given. Makie supports `String` which is used for all normal text and `LaTeXString` which layouts mathematical expressions using `MathTeXEngine.jl`."
    text = ""
    "Sets the color of the text. One can set one color per glyph by passing a `Vector{<:Colorant}`, or one colorant for the whole text. If color is a vector of numbers, the colormap args are used to map the numbers to colors."
    color = @inherit textcolor
    "Sets the font. Can be a `Symbol` which will be looked up in the `fonts` dictionary or a `String` specifying the (partial) name of a font or the file path of a font file"
    font = @inherit font
    "Used as a dictionary to look up fonts specified by `Symbol`, for example `:regular`, `:bold` or `:italic`."
    fonts = @inherit fonts
    "Sets the color of the outline around a marker."
    strokecolor = (:black, 0.0)
    "Sets the width of the outline around a marker."
    strokewidth = 0
    "Sets the alignment of the string w.r.t. `position`. Uses `:left, :center, :right, :top, :bottom, :baseline` or fractions."
    align = (:left, :bottom)
    "Rotates text around the given position"
    rotation = 0.0
    "The fontsize in units depending on `markerspace`."
    fontsize = @inherit fontsize
    "Deprecated: Specifies the position of the text. Use the positional argument to `text` instead."
    position = (0.0, 0.0)
    "Sets the alignment of text w.r.t its bounding box. Can be `:left, :center, :right` or a fraction. Will default to the horizontal alignment in `align`."
    justification = automatic
    "The lineheight multiplier."
    lineheight = 1.0
    "Sets the space in which `fontsize` acts. See `Makie.spaces()` for possible inputs."
    markerspace = :pixel
    "Controls whether the model matrix (without translation) applies to the glyph itself, rather than just the positions. (If this is true, `scale!` and `rotate!` will affect the text glyphs.)"
    transform_marker = false
    "Sets the color of the glow effect around the text."
    glowcolor = (:black, 0.0)
    "Sets the size of a glow effect around the text."
    glowwidth = 0.0
    "The offset of the text from the given position in `markerspace` units."
    offset = (0.0, 0.0)
    "Specifies a linewidth limit for text. If a word overflows this limit, a newline is inserted before it. Negative numbers disable word wrapping."
    word_wrap_width = -1
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
    fxaa = false
end

function deprecated_attributes(::Type{<:Text})
    (
        (; attribute = :textsize, message = "`textsize` has been renamed to `fontsize` in Makie v0.19. Please change all occurrences of `textsize` to `fontsize` or revert back to an earlier version.", error = true),
    )
end

"""
    voxels(x, y, z, chunk::Array{<:Real, 3})
    voxels(chunk::Array{<:Real, 3})

Plots a chunk of voxels centered at 0. Optionally the placement and scaling of
the chunk can be given as range-like x, y and z. (Only the extrema are
considered here. Voxels are always uniformly sized.)

Internally voxels are represented as 8 bit unsigned integer, with `0x00` always
being an invisible "air" voxel. Passing a chunk with matching type will directly
set those values. Note that color handling is specialized for the internal
representation and may behave a bit differently than usual.

Note that `voxels` is currently considered experimental and may still see breaking
changes in patch releases.
"""
@recipe Voxels begin
    "A function that controls which values in the input data are mapped to invisible (air) voxels."
    is_air = x -> isnothing(x) || ismissing(x) || isnan(x)
    """
    Deprecated - use uv_transform
    """
    uvmap = nothing
    """
    To use texture mapping `uv_transform` needs to be defined and `color` needs to be an image.
    The `uv_transform` can be given as a `Vector` where each index maps to a `UInt8` voxel id (skipping 0),
    or as a `Matrix` where the second index maps to a side following the order `(-x, -y, -z, +x, +y, +z)`.
    Each element acts as a `Mat{2, 3, Float32}` which is applied to `Vec3f(uv, 1)`, where uv's are generated to run from 0..1 for each voxel.
    The result is then used to sample the texture.
    UV transforms have a bunch of shorthands you can use, for example `(Point2f(x, y), Vec2f(xscale, yscale))`.
    They are listed in `?Makie.uv_transform`.
    """
    uv_transform = nothing
    "Controls whether the texture map is sampled with interpolation (i.e. smoothly) or not (i.e. pixelated)."
    interpolate = false
    """
    Controls the render order of voxels. If set to `false` voxels close to the viewer are
    rendered first which should reduce overdraw and yield better performance. If set to
    `true` voxels are rendered back to front enabling correct order for transparent voxels.
    """
    depthsorting = false
    "Sets the gap between adjacent voxels in units of the voxel size. This needs to be larger than 0.01 to take effect."
    gap = 0.0

    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...

    """
    Sets colors per voxel id, skipping `0x00`. This means that a voxel with id 1 will grab
    `plot.colors[1]` and so on up to id 255. This can also be set to a Matrix of colors,
    i.e. an image for texture mapping.
    """
    color = nothing
end


"""
    poly(vertices, indices; kwargs...)
    poly(points; kwargs...)
    poly(shape; kwargs...)
    poly(mesh; kwargs...)

Plots a polygon based on the arguments given.
When vertices and indices are given, it functions similarly to `mesh`.
When points are given, it draws one polygon that connects all the points in order.
When a shape is given (essentially anything decomposable by `GeometryBasics`), it will plot `decompose(shape)`.

    poly(coordinates, connectivity; kwargs...)

Plots polygons, which are defined by
`coordinates` (the coordinates of the vertices) and
`connectivity` (the edges between the vertices).
"""
@recipe Poly begin
    """
    Sets the color of the poly. Can be a `Vector{<:Colorant}` for per vertex colors or a single `Colorant`.
    A `Matrix{<:Colorant}` can be used to color the mesh with a texture, which requires the mesh to contain texture coordinates.
    Vector or Matrices of numbers can be used as well, which will use the colormap arguments to map the numbers to colors.
    One can also use a `<: AbstractPattern`, to cover the poly with a regular pattern, e.g. for hatching.
    """
    color = @inherit patchcolor
    "Sets the color of the outline around a marker."
    strokecolor = @inherit patchstrokecolor
    "Sets the colormap that is sampled for numeric `color`s."
    strokecolormap = @inherit colormap
    "Sets the width of the outline."
    strokewidth = @inherit patchstrokewidth
    """
    Sets the dash pattern of the line. Options are `:solid` (equivalent to `nothing`), `:dot`, `:dash`, `:dashdot` and `:dashdotdot`.
    These can also be given in a tuple with a gap style modifier, either `:normal`, `:dense` or `:loose`.
    For example, `(:dot, :loose)` or `(:dashdot, :dense)`.

    For custom patterns have a look at [`Makie.Linestyle`](@ref).
    """
    linestyle = nothing
    linecap = @inherit linecap
    joinstyle = @inherit joinstyle
    miter_limit = @inherit miter_limit

    shading = NoShading

    cycle = [:color => :patchcolor]
    """
    Depth shift of stroke plot. This is useful to avoid z-fighting between the stroke and the fill.
    """
    stroke_depth_shift = -1.0f-5
    mixin_generic_plot_attributes()...
    mixin_colormap_attributes()...
end

"""
    wireframe(x, y, z)
    wireframe(positions)
    wireframe(mesh)

Draws a wireframe, either interpreted as a surface or as a mesh.
"""
@recipe Wireframe begin
    documented_attributes(LineSegments)...
    depth_shift = -1f-5
end

"""
    arrows(points, directions; kwargs...)
    arrows(x, y, u, v)
    arrows(x::AbstractVector, y::AbstractVector, u::AbstractMatrix, v::AbstractMatrix)
    arrows(x, y, z, u, v, w)
    arrows(x, y, [z], f::Function)

Plots arrows at the specified points with the specified components.
`u` and `v` are interpreted as vector components (`u` being the x
and `v` being the y), and the vectors are plotted with the tails at
`x`, `y`.

If `x, y, u, v` are `<: AbstractVector`, then each 'row' is plotted
as a single vector.

If `u, v` are `<: AbstractMatrix`, then `x` and `y` are interpreted as
specifications for a grid, and `u, v` are plotted as arrows along the
grid.

`arrows` can also work in three dimensions.

If a `Function` is provided in place of `u, v, [w]`, then it must accept
a `Point` as input, and return an appropriately dimensioned `Point`, `Vec`,
or other array-like output.
"""
@recipe Arrows (points, directions) begin
    "Sets the color of arrowheads and lines. Can be overridden separately using `linecolor` and `arrowcolor`."
    color = :black
    """Scales the size of the arrow head. This defaults to
    `0.3` in the 2D case and `Vec3f(0.2, 0.2, 0.3)` in the 3D case. For the latter
    the first two components scale the radius (in x/y direction) and the last scales
    the length of the cone. If the arrowsize is set to 1, the cone will have a
    diameter and length of 1."""
    arrowsize = automatic
    """Defines the marker (2D) or mesh (3D) that is used as
    the arrow head. The default for is `'▲'` in 2D and a cone mesh in 3D. For the
    latter the mesh should start at `Point3f(0)` and point in positive z-direction."""
    arrowhead = automatic
    """Defines the mesh used to draw the arrow tail in 3D.
    It should start at `Point3f(0)` and extend in negative z-direction. The default
    is a cylinder. This has no effect on the 2D plot."""
    arrowtail = automatic
    """Sets the color used for the arrow tail which is represented by a line in 2D.
    Will copy `color` if set to `automatic`.
    """
    linecolor = automatic
    """Sets the linestyle used in 2D. Does not apply to 3D plots."""
    linestyle = nothing
    """Sets how arrows are positioned. By default arrows start at
    the given positions and extend along the given directions. If this attribute is
    set to `:head`, `:lineend`, `:tailend`, `:headstart` or `:center` the given
    positions will be between the head and tail of each arrow instead."""
    align = :origin
    """By default the lengths of the directions given to `arrows`
    are used to scale the length of the arrow tails. If this attribute is set to
    true the directions are normalized, skipping this scaling."""
    normalize = false
    """Scales the length of the arrow tail."""
    lengthscale = 1f0

    """Defines the number of angle subdivisions used when generating
    the arrow head and tail meshes. Consider lowering this if you have performance
    issues. Only applies to 3D plots."""
    quality = 32
    markerspace = :pixel

    mixin_generic_plot_attributes()...
    mixin_shading_attributes()...
    mixin_colormap_attributes()...

    fxaa = automatic
    """Scales the width/diameter of the arrow tail.
    Defaults to `1` for 2D and `0.05` for the 3D case."""
    linewidth = automatic
    """Sets the color of the arrow head. Will copy `color` if set to `automatic`."""
    arrowcolor = automatic
end
