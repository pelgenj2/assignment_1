class Employee
  attr_accessor :state, :plant, :dept, :empid, :name, :count
  
  def initialize(state, plant, dept, empid, name, count)
    @state, @plant, @dept, @empid, @name, @count = state, plant, dept, empid, name, count
  end
end

input = File.open("widgets.csv", "r")

header = []
employees_unsorted = []

head = input.readline
headsplit = head.split(",")
header << Employee.new(headsplit[0], headsplit[1], headsplit[2], headsplit[3], headsplit[4], headsplit[5])
line_count = 0
input.each_line do |line|
  linesplit = line.split(",")
  employees_unsorted << Employee.new(linesplit[0].to_i, linesplit[1].to_i, linesplit[2].to_i, linesplit[3].to_i, linesplit[4], linesplit[5].strip.to_i)
  line_count += 1
end

#Sort array
employees = employees_unsorted.sort_by{|employee| [employee.state, employee.plant, employee.dept]}

dept_counter = 0
plant_counter = 0
state_counter = 0

dept_counter = employees[0].count
plant_counter = dept_counter
state_counter = dept_counter
grand_total = 0

i = 0

flout = File.new "widgets.out","w"

flout.write sprintf("%s %s %s %s %s %10s\n\n", header[0].state, header[0].plant, header[0].dept, header[0].empid, header[0].count.strip, header[0].name)
flout.write sprintf("%5d %5d %4d %5d %5d....%s\n", employees[0].state, employees[0].plant, employees[0].dept, employees[0].empid, employees[0].count, employees[0].name)

while i < line_count-1
  grand_total += employees[i].count
  if employees[i].state == employees[i+1].state
    state_counter += employees[i+1].count
    if employees[i].plant == employees[i+1].plant
      plant_counter += employees[i+1].count
      if employees[i].dept == employees[i+1].dept
        dept_counter += employees[i+1].count
        flout.write sprintf("%5d %5d %4d %5d %5d....%s\n", employees[i+1].state, employees[i+1].plant, employees[i+1].dept, employees[i+1].empid, employees[i+1].count, employees[i+1].name)
      else
        flout.write sprintf("\n\n%28d TOTAL FOR DEPT %2s\n\n\n", dept_counter, "*")
        flout.write sprintf("%5d %5d %4d %5d %5d....%s\n", employees[i+1].state, employees[i+1].plant, employees[i+1].dept, employees[i+1].empid, employees[i+1].count, employees[i+1].name)
        dept_counter = employees[i+1].count
      end
    else
      flout.write sprintf("\n\n%28d TOTAL FOR DEPT %2s\n", dept_counter, "*")
      flout.write sprintf("%28d TOTAL FOR PLANT %2s\n\n\n", plant_counter, "**")
      flout.write sprintf("%5d %5d %4d %5d %5d....%s\n", employees[i+1].state, employees[i+1].plant, employees[i+1].dept, employees[i+1].empid, employees[i+1].count, employees[i+1].name)
      plant_counter = employees[i+1].count
      dept_counter = employees[i+1].count
    end
  else
    flout.write sprintf("\n\n%28d TOTAL FOR DEPT %2s\n", dept_counter, "*")
    flout.write sprintf("%28d TOTAL FOR PLANT %2s\n", plant_counter, "**")
    flout.write sprintf("%28d TOTAL FOR STATE %2s\n\n\n", state_counter, "***")
    flout.write sprintf("%5d %5d %4d %5d %5d....%s\n", employees[i+1].state, employees[i+1].plant, employees[i+1].dept, employees[i+1].empid, employees[i+1].count, employees[i+1].name)
    state_counter = employees[i+1].count
    plant_counter = employees[i+1].count
    dept_counter = employees[i+1].count
  end
  
  i += 1
end
grand_total += employees[-1].count
flout.write sprintf("\n\n%28d TOTAL FOR DEPT %2s\n", dept_counter, "*")
flout.write sprintf("%28d TOTAL FOR PLANT %2s\n", plant_counter, "**")
flout.write sprintf("%28d TOTAL FOR STATE %2s\n\n", state_counter, "***")
flout.write sprintf("\n%28d GRAND TOTAL%9s", grand_total, "****")
flout.close

puts "Data has been written to widgets.out"