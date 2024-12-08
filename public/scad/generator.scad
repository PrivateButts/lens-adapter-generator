// Load the male and female lens mount models
male_mount = "e.stl";
female_mount = "ef.stl";

// Parameters for the hollow cone
cone_height = 50;
cone_male_inner_diameter = 49;
cone_male_outer_diameter = 49;
cone_female_inner_diameter = 52;
cone_female_outer_diameter = 52;
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
module hollow_cone(height, bottom_inner_diameter, bottom_outer_diameter, top_inner_diameter, top_outer_diameter)
{
    {
        difference()
        {
            // Outer cone
            linear_extrude(height = height, scale = bottom_outer_diameter / top_outer_diameter)
                circle(d = top_outer_diameter, $fn = segment_count);
            // Inner cone
            translate([ 0, 0, -1 ])
                linear_extrude(height = height + 2, scale = bottom_inner_diameter / top_inner_diameter)
                    circle(d = top_inner_diameter, $fn = segment_count);
        }
    }
}

// Assemble the lens adapter
module lens_adapter()
{
    union()
    {
        // Position the male lens mount
        translate([ 0, 0, 0 ]) male_lens_mount();

        hollow_cone(cone_height, cone_female_inner_diameter, cone_female_outer_diameter, cone_male_inner_diameter,
                    cone_male_outer_diameter);

        // Position the female lens mount
        translate([ 0, 0, cone_height ]) female_lens_mount();
    }
}

// Generate the lens adapter
lens_adapter();