-- Copyright 2016 The Cartographer Authors
--
-- Licensed under the Apache License, Version 2.0 (the "License");
-- you may not use this file except in compliance with the License.
-- You may obtain a copy of the License at
--
--      http://www.apache.org/licenses/LICENSE-2.0
--
-- Unless required by applicable law or agreed to in writing, software
-- distributed under the License is distributed on an "AS IS" BASIS,
-- WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
-- See the License for the specific language governing permissions and
-- limitations under the License.

include "map_builder.lua"
include "trajectory_builder.lua"

options = {
  map_builder = MAP_BUILDER,
  trajectory_builder = TRAJECTORY_BUILDER,
  map_frame = "map",
  tracking_frame = "imu_link",
  published_frame = "base_link",
  odom_frame = "odom",
  provide_odom_frame = true,
  publish_frame_projected_to_2d = true,
  use_odometry = false,
  use_nav_sat = false,
  use_landmarks = false,
  num_laser_scans = 0,
  num_multi_echo_laser_scans = 0,
  num_subdivisions_per_laser_scan = 1,
  num_point_clouds = 1,
  lookup_transform_timeout_sec = 0.2,
  submap_publish_period_sec = 0.3,
  pose_publish_period_sec = 5e-3,
  trajectory_publish_period_sec = 30e-3,
  rangefinder_sampling_ratio = 1.,
  odometry_sampling_ratio = 1,
  fixed_frame_pose_sampling_ratio = 0.1,
  imu_sampling_ratio = 0.1,
  landmarks_sampling_ratio = 1.,
}

-- GENERAL
MAP_BUILDER.use_trajectory_builder_2d = true

-- LOCAL SLAM
TRAJECTORY_BUILDER_2D.voxel_filter_size = 0.05  --0.15
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.translation_weight = 1e-3
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.rotation_weight = 1e-3
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.occupied_space_weight = 1e5 --2e1 before, worked
TRAJECTORY_BUILDER_2D.ceres_scan_matcher.ceres_solver_options.max_num_iterations = 100
TRAJECTORY_BUILDER_2D.use_imu_data = false
-- Nr ROS msgs that make one complete scan, Kitti (Velodyne): 1 pointcloud/msg 
TRAJECTORY_BUILDER_2D.num_accumulated_range_data = 1
-- Define amount of scans per submap
TRAJECTORY_BUILDER_2D.submaps.num_range_data = 20 
-- Online SLAM
TRAJECTORY_BUILDER_2D.use_online_correlative_scan_matching = false
-- TRAJECTORY_BUILDER_nD.real_time_correlative_scan_matcher.linear_search_window
-- TRAJECTORY_BUILDER_nD.real_time_correlative_scan_matcher.angular_search_window
-- TRAJECTORY_BUILDER_nD.real_time_correlative_scan_matcher.translation_delta_cost_weight
-- TRAJECTORY_BUILDER_nD.real_time_correlative_scan_matcher.rotation_delta_cost_weight
-- Tweaking Performance of 2D setup
-- TRAJECTORY_BUILDER_3D.ceres_scan_matcher.ceres_solver_options.num_threads = 6
TRAJECTORY_BUILDER_2D.submaps.grid_options_2d.resolution = 0.1  -- 0.05
TRAJECTORY_BUILDER_2D.min_z = -1. -- -1.5
TRAJECTORY_BUILDER_2D.max_z = 1.  -- 1.5

-- -- GLOBAL SLAM
POSE_GRAPH.optimize_every_n_nodes = 0 
-- POSE_GRAPH.max_num_final_iterations = 200
-- -- MAP_BUILDER.num_background_threads = 7
-- POSE_GRAPH.optimization_problem.huber_scale = 5e2 --5e2
-- POSE_GRAPH.constraint_builder.sampling_ratio = 0.03
-- POSE_GRAPH.optimization_problem.ceres_solver_options.max_num_iterations = 15
-- POSE_GRAPH.constraint_builder.min_score = 0.7 -- 0.62
-- POSE_GRAPH.constraint_builder.global_localization_min_score = 0.66

-- -- Added enabling loop closure on Teraki datasets
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.linear_search_window = 50.
-- POSE_GRAPH.constraint_builder.fast_correlative_scan_matcher.angular_search_window = math.rad(45.)

return options


--TRAJECTORY_BUILDER_2D.imu_gravity_time_constant = 10.
--TRAJECTORY_BUILDER_2D.min_range = 2.
--TRAJECTORY_BUILDER_2D.max_range = 50.
-- Search Window for local SLAM
--TRAJECTORY_BUILDER_2D.real_time_correlative_scan_matcher.linear_search_window = 0.