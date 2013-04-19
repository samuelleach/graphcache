require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  setup do
    @node = nodes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node" do
    assert_difference('Node.count') do
      post :create, node: { created_at: @node.created_at, description: @node.description, followers_count: @node.followers_count, friends_count: @node.friends_count, group_id: @node.group_id, id: @node.id, location: @node.location, name: @node.name, profile_image_url_https: @node.profile_image_url_https, protected: @node.protected, statuses_count: @node.statuses_count }
    end

    assert_redirected_to node_path(assigns(:node))
  end

  test "should show node" do
    get :show, id: @node
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @node
    assert_response :success
  end

  test "should update node" do
    put :update, id: @node, node: { created_at: @node.created_at, description: @node.description, followers_count: @node.followers_count, friends_count: @node.friends_count, group_id: @node.group_id, id: @node.id, location: @node.location, name: @node.name, profile_image_url_https: @node.profile_image_url_https, protected: @node.protected, statuses_count: @node.statuses_count }
    assert_redirected_to node_path(assigns(:node))
  end

  test "should destroy node" do
    assert_difference('Node.count', -1) do
      delete :destroy, id: @node
    end

    assert_redirected_to nodes_path
  end
end
