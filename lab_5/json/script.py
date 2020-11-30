filename = "test"

with open(filename + ".json", 'r') as from_file:
    to_file = open(filename + "_json_data.json", 'w')
    for line in from_file:
        line = line.replace(',', '')
        line = line.replace('[', '')
        line = line.replace(']', '')
        line = line.replace('\\r', '')
        line = line.replace('\\n', '')
        if line.count('}') == 0:
            line = line.replace('\n', '')
            if line.count('{') == 0 and '"answer"' not in line:
                line += ','
        to_file.write(line)
    to_file.close()
    
