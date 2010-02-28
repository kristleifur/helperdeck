#!/usr/bin/env ruby

require 'yaml'

triangles = []
triangles << "this is ►"
triangles << "this is ▼"
triangles << "this is ▸"
triangles << "this is ▾"

triangles.each do | triangle |
  puts triangle.to_yaml()
end