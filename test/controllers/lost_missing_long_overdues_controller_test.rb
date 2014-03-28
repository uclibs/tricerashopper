require 'test_helper'

class LostMissingLongOverduesControllerTest < ActionController::TestCase
  setup do
    @lost_missing_long_overdue = lost_missing_long_overdues(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lost_missing_long_overdues)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lost_missing_long_overdue" do
    assert_difference('LostMissingLongOverdue.count') do
      post :create, lost_missing_long_overdue: { barcode: @lost_missing_long_overdue.barcode, bib_number: @lost_missing_long_overdue.bib_number, call_number: @lost_missing_long_overdue.call_number, checkouts: @lost_missing_long_overdue.checkouts, due_date: @lost_missing_long_overdue.due_date, imprint: @lost_missing_long_overdue.imprint, isbn: @lost_missing_long_overdue.isbn, item_number: @lost_missing_long_overdue.item_number, last_checkout: @lost_missing_long_overdue.last_checkout, location: @lost_missing_long_overdue.location, note: @lost_missing_long_overdue.note, status: @lost_missing_long_overdue.status, title: @lost_missing_long_overdue.title, volume: @lost_missing_long_overdue.volume }
    end

    assert_redirected_to lost_missing_long_overdue_path(assigns(:lost_missing_long_overdue))
  end

  test "should show lost_missing_long_overdue" do
    get :show, id: @lost_missing_long_overdue
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @lost_missing_long_overdue
    assert_response :success
  end

  test "should update lost_missing_long_overdue" do
    patch :update, id: @lost_missing_long_overdue, lost_missing_long_overdue: { barcode: @lost_missing_long_overdue.barcode, bib_number: @lost_missing_long_overdue.bib_number, call_number: @lost_missing_long_overdue.call_number, checkouts: @lost_missing_long_overdue.checkouts, due_date: @lost_missing_long_overdue.due_date, imprint: @lost_missing_long_overdue.imprint, isbn: @lost_missing_long_overdue.isbn, item_number: @lost_missing_long_overdue.item_number, last_checkout: @lost_missing_long_overdue.last_checkout, location: @lost_missing_long_overdue.location, note: @lost_missing_long_overdue.note, status: @lost_missing_long_overdue.status, title: @lost_missing_long_overdue.title, volume: @lost_missing_long_overdue.volume }
    assert_redirected_to lost_missing_long_overdue_path(assigns(:lost_missing_long_overdue))
  end

  test "should destroy lost_missing_long_overdue" do
    assert_difference('LostMissingLongOverdue.count', -1) do
      delete :destroy, id: @lost_missing_long_overdue
    end

    assert_redirected_to lost_missing_long_overdues_path
  end
end
