// Load the male and female lens mount models
male_mount = "e.stl";
female_mount = "ef.stl";

// Parameters for the hollow cone
cone_height = 50;
cone_male_diameter = 49;
cone_female_diameter = 52;
wall_thickness = 6;
segment_count = 100;

// Import the male lens mount
module male_lens_mount()
{
    import(male_mount);
}

// Import the female lens mount
module female_lens_mount()
{
    import(female_mount);
}

// Create a hollow cone
module hollow_cone(height, bottom_diameter, top_diameter, thickness)
{
    difference()
    {
        // Outer cone
        linear_extrude(height = height, scale = top_diameter / bottom_diameter)
            circle(d = bottom_diameter + wall_thickness, $fn = segment_count);
        // Inner cone
        translate([ 0, 0, -thickness / 2 ])
            linear_extrude(height = height + wall_thickness, scale = top_diameter / bottom_diameter)
                circle(d = bottom_diameter, $fn = segment_count);
    }
}

// Assemble the lens adapter
module lens_adapter()
{
    union()
    {
        // Position the male lens mount
        translate([ 0, 0, 0 ]) male_lens_mount();

        hollow_cone(cone_height, cone_male_diameter, cone_female_diameter, wall_thickness);

        // Position the female lens mount
        translate([ 0, 0, cone_height ]) female_lens_mount();
    }
}

// Generate the lens adapter
lens_adapter();