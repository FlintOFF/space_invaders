require 'test_helper'

class TaskFlowTest < ActionDispatch::IntegrationTest
  def setup
    @radar_frame = FrameService.load_from_file(file_fixture('radar_1.txt'))
    target_1_frame = FrameService.load_from_file(file_fixture('radar_1_target_1.txt'))
    target_2_frame = FrameService.load_from_file(file_fixture('radar_1_target_2.txt'))
    @radar = FactoryBot.create(:radar, FrameService.info(@radar_frame))
    @target_1 = FactoryBot.create(:target, radar: @radar, kind: :enemy, frame: target_1_frame)
    @target_2 = FactoryBot.create(:target, radar: @radar, kind: :enemy, frame: target_2_frame)

    @user = FactoryBot.create(:user)
    @headers = { 'Content-Type': 'application/json', 'Authorization': "Bearer #{generate_token(@user)}" }
  end

  test 'Detect targets on radar frame' do
    post '/api/tasks', params: { radar_id: @radar.id, frame: @radar_frame }.to_json, headers: @headers
    assert response.status == 201

    expected = [
      { :errors=>{}, :percent=>80, :position=>[0, 7, 18, 8], :target_id=>@target_2.id, :overlap_percent=>88 },
      { :errors=>{}, :percent=>88, :position=>[0, 8, 42, 8], :target_id=>@target_2.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>88, :position=>[1, 8, 74, 11], :target_id=>@target_1.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>86, :position=>[12, 8, 85, 11], :target_id=>@target_1.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>91, :position=>[13, 8, 60, 11], :target_id=>@target_1.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>84, :position=>[15, 8, 35, 8], :target_id=>@target_2.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>86, :position=>[28, 8, 16, 8], :target_id=>@target_2.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>86, :position=>[41, 8, 82, 8], :target_id=>@target_2.id, :overlap_percent=>100 },
      { :errors=>{}, :percent=>93, :position=>[45, 5, 17, 8], :target_id=>@target_2.id, :overlap_percent=>63 }
    ]

    results = JSON.parse(response.body, { symbolize_names: true })[:results]
    results = results.sort_by{ |h| [h[:position][0], h[:position][2], h[:position][1], h[:position][3]] }

    assert results == expected
  end
end
