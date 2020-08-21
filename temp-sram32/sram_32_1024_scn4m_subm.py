word_size = 32
# Number of words in the memory
num_words = 1024

# Technology to use in $OPENRAM_TECH
tech_name = "scn4m_subm"

# You can use the technology nominal corner only
nominal_corner_only = False
# Or you can specify particular corners
# Process corners to characterize
process_corners = ["TT"]
# Voltage corners to characterize
supply_voltages = [5.0 ]
# Temperature corners to characterize
temperatures = [ 27 ]

# Output directory for the results
output_path= "temp"
#OUtput file base name
output_name = "sram_{0}_{1}_{2}".format(word_size,num_words,tech_name)

