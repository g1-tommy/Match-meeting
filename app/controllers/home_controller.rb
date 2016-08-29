class HomeController < ApplicationController
  before_action :require_login
  
  # REDIRECTION FOR USER CONTROL
  # def index
  #   if user_signed_in?
  #     redirect_to '/home/user_main'
  #   elsif owner_signed_in?
  #     redirect_to '/home/owner_main'
  #   else
  #     redirect_to '/home/intro'
  #   end
  # end
  
  # LIKES
  def likes
    likes = Place.find(params[:pid])
    likes.likes = likes.likes + 1
    likes.who_likes_it = "#{likes.who_likes_it}#{params[:uid]}|"
    if likes.save then
      respond_to do |format|
       format.json { 
          render json: {:likes => likes.likes}
       }
      end
    end
  end
  # END 
  
  # CREATE
  def create_group
    if owner_signed_in? then
      unauthorized
    else
      if Timetable.where("user_id = ?", current_user.id).count == 0 then
        flash[:timetable] = "시간표 등록을 하지 않으실 경우 그룹 등록이 불가합니다."
        redirect_to mypage_path
      else
      end
    end
  end
  
  def create_group_exec
    if user_signed_in? then
      insert = Group.new
      insert.school = params[:school]
      insert.name = params[:name]
      insert.content = params[:content]
      insert.member = params[:max].to_i
      insert.creator = current_user.email
      if insert.save then
        flash[:created] = "생성되었습니다."
        redirect_to mypage_path
      else
        flash[:error] = "저장 중 문제가 발생하였습니다. 다시 시도해주세요."
        redirect_to root_path
      end
      
    else
      unauthorized
    end
  end
  
  def create_place
    if user_signed_in? then
      unauthorized
    end
  end
  
  def create_place_exec
    if owner_signed_in? then
      if params[:open].to_i > params[:close].to_i then
        flash[:time] = "매장 오픈/클로징 시간이 올바르지 않습니다. 생성 정보를 처음부터 다시 입력하여주시기 바랍니다."
        redirect_to create_place_path
      else
        insert = Place.new
        insert.name = params[:name]
        insert.content = params[:content]
        insert.location = params[:location]
        insert.open = params[:open]
        insert.close = params[:close]
        insert.creator = current_owner.email
        insert.likes = 0
        insert.who_likes_it = ""
        if insert.save then
          flash[:created] = "생성되었습니다."
          redirect_to mypage_path
        else
          flash[:error] = "저장 중 문제가 발생하였습니다. 다시 시도해주세요."
          redirect_to root_path
        end
      end
    else
      unauthorized
    end
  end
  
  # END
  
  # MYPAGE
  def mypage
    if user_signed_in? then
      @timetable = Timetable.where(user_id: current_user.id)
      
      if @timetable.count == 0 then
        @timetable_msg = true
      else
        @timetable = @timetable.first
        @timetable = [[@timetable.mon_time_09, @timetable.mon_time_10, @timetable.mon_time_11, @timetable.mon_time_12, @timetable.mon_time_13, @timetable.mon_time_14, @timetable.mon_time_15, @timetable.mon_time_16, @timetable.mon_time_17, @timetable.mon_time_18, @timetable.mon_time_19],
                      [@timetable.tue_time_09, @timetable.tue_time_10, @timetable.tue_time_11, @timetable.tue_time_12, @timetable.tue_time_13, @timetable.tue_time_14, @timetable.tue_time_15, @timetable.tue_time_16, @timetable.tue_time_17, @timetable.tue_time_18, @timetable.tue_time_19],
                      [@timetable.wed_time_09, @timetable.wed_time_10, @timetable.wed_time_11, @timetable.wed_time_12, @timetable.wed_time_13, @timetable.wed_time_14, @timetable.wed_time_15, @timetable.wed_time_16, @timetable.wed_time_17, @timetable.wed_time_18, @timetable.wed_time_19],
                      [@timetable.thu_time_09, @timetable.thu_time_10, @timetable.thu_time_11, @timetable.thu_time_12, @timetable.thu_time_13, @timetable.thu_time_14, @timetable.thu_time_15, @timetable.thu_time_16, @timetable.thu_time_17, @timetable.thu_time_18, @timetable.thu_time_19],
                      [@timetable.fri_time_09, @timetable.fri_time_10, @timetable.fri_time_11, @timetable.fri_time_12, @timetable.fri_time_13, @timetable.fri_time_14, @timetable.fri_time_15, @timetable.fri_time_16, @timetable.fri_time_17, @timetable.fri_time_18, @timetable.fri_time_19]
                      ]
        
        @mon = Array.new
        @tue = Array.new
        @wed = Array.new
        @thu = Array.new
        @fri = Array.new
        
        @timetable[0].each do |mon|
          @mon << timeType(mon)
        end
        
        @timetable[1].each do |tue|
          @tue << timeType(tue)
        end
        
        @timetable[2].each do |wed|
          @wed << timeType(wed)
        end
        
        @timetable[3].each do |thu|
          @thu << timeType(thu)
        end
        
        @timetable[4].each do |fri|
          @fri << timeType(fri)
        end
      end
      
      @session = current_user.email
      @affiliated = Group.where("affiliation LIKE ?", "%#{current_user.email}%")
      @myGroup = Group.where(creator: @session)
      
      @myResv = Array.new
      @myGroup.each do |g|
         r = Reservation.where("group_id =?", g.id)
         r.each do |s|
           @myResv << [s.id, Place.find(s.place_id).name]
         end
      end

    elsif owner_signed_in? then
      @session = current_owner.email
      @reservation = Reservation.where("place_id =?", )
    end
  end
  # END
  
  # GROUP
  def group
    if user_signed_in? then
      @school = current_user.school
      # @group = Group.all.paginate(:page => params[:page], :per_page => 8).order('created_at DESC')
      @group = Group.where(:school => @school).paginate(:page => params[:page], :per_page => 8).order('created_at DESC')
    else
      @group = Group.paginate(:page => params[:page], :per_page => 8).order('created_at DESC')
    end
  end
  
  def group_apply_exec
    if user_signed_in? then
      if Timetable.where("user_id = ?", current_user.id).count == 0 then
        flash[:timetable] = "시간표 등록을 하지 않으실 경우 그룹 가입이 불가합니다."
        redirect_to mypage_path
      else
         if params.has_key?(:group_id) then
          apply = Group.find(params[:group_id])
          apply.affiliation = "#{apply.affiliation}#{current_user.email}|"
          apply.member = apply.member - 1
          if apply.save then
            flash[:success] = '그룹에 가입되었습니다.'
            redirect_to  "/find/group/detail/" + params[:group_id]
          end
         else
          unauthorized
         end
      end
    
    else
      unauthorized
    end
  end
  
  def group_detail
    @group = Group.find(params[:group_id])
    if owner_signed_in? then
      @creator = false
      @signed = "not_user"
    else
      if Group.where("id = ? AND creator = ?", params[:group_id], current_user.email).count == 1 then
        @creator = true
      else
        @creator = false
        if Group.where("id = ? AND affiliation LIKE ?", params[:group_id], "%#{current_user.email}%").count == 1 then
          @signed = true
        else
          @signed = false
        end
      end
    end
    if @creator == true or @signed == true then
     memberIds = Array.new
     unless @group.affiliation == nil or @group.affiliation == "" then
       memberIds << User.where(email: @group.creator).first.id
       @group.affiliation.split('|').each do |m|
         memberIds << User.where(email: m).first.id
       end
       @canbeGatheredAt = whenTogether memberIds
     end
    end
  end

  def group_destroy_exec
    if user_signed_in? then
      if Group.find(params[:group_id]).creator == current_user.email then
        if Group.find(params[:group_id]).delete then
          flash[:success] = "그룹을 삭제하였습니다."
          redirect_to mypage_path
        end   
      else
        delete = Group.find(params[:group_id])
        delete.member = delete.member + 1
        delete.affiliation = delete.affiliation.gsub(current_user.email + '|', "")
        if delete.save then
          flash[:success] = "탈퇴하였습니다."
          redirect_to mypage_path
        end    
      end
    else
      unauthorized
    end
  end
  
  def group_edit
    if user_signed_in? then
      @group = Group.find(params[:group_id])
      if @group.affiliation == nil then
        @affiliated = 0
      else
        @affiliated = @group.affiliation.split('|').count
      end
      
      unless @group.creator == current_user.email then
        unauthorized
      end
    else
      unauthorized
    end
  end
  
  def group_edit_exec
    if user_signed_in? then
      @group = Group.find(params[:group_id])
      @group.name = params[:name]
      @group.content = params[:content]
      if @group.affiliation == nil or @group.affiliation == "" then
        @affiliated = 0
      else
        @affiliated = @group.affiliation.split('|').count
      end
      @group.member = params[:max].to_i - @affiliated.to_i
      if @group.save then
        flash[:succeess] = "수정이 완료되었습니다."
        redirect_to mypage_path
      end
    else
      unauthorized
    end
  end
  
  def group_search
    @result = Group.where(:school => current_user.school).where("name LIKE ?","%#{params[:query]}%").paginate(:page => params[:page], :per_page => 8).order('created_at DESC')
  end
  # END
  
  # PLACE
  def place
    @place = Place.all.paginate(:page => params[:page], :per_page => 8).order('created_at DESC')
  end
  
  def place_detail
    @place = Place.find(params[:place_id])
    if owner_signed_in? then
      @creator = (@place.creator == current_owner.email)
    else
      @creator = nil
    end
  end
  
  def place_apply_exec
    if user_signed_in? then
      resv = Reservation.new
      resv.place_id = params[:place_id]
      resv.group_id = params[:group_id]
      resv.confirm = 0
      resv.schedule = DateTime.parse("#{params[:selectedDate]} #{params[:resv_time]}")
      resv.duration = DateTime.parse("#{params[:selectedDate]} #{params[:duration_time]}")
      if resv.save then
        flash[:success] = "예약이 완료되었습니다. 대관 관계자의 사정으로 인한 예약 반려가 될 가능성이 있으므로 방문 직전 반드시 예약 승인 여부를 확인하시어 방문하시기 바랍니다."
        redirect_to '/mypage/reservations/'+resv.id.to_s
      else
        error_occurred
      end
    else
      unauthorized
    end
  end
  
  def place_apply_before
    unless user_signed_in? then
      unauthorized
    else
      @myGroup = Group.where(creator: current_user.email)
    end
  end
  
  def place_edit
    unless owner_signed_in? then
      unauthorized
    else
      @place = Place.find(params[:place_id])
      unless @place.creator == current_owner.email then
        unauthorized
      end
    end
  end
  
  def place_edit_exec
    if owner_signed_in? then
      @place = Place.find(params[:place_id])
      @place.name = params[:name]
      @place.content = params[:content]
      @place.location = params[:location]
      @place.open = params[:open]
      @place.close = params[:close]
      if @place.save then
        flash[:succeess] = "수정이 완료되었습니다."
        redirect_to mypage_path
      end
    else
      unauthorized
    end
  end
  
  def place_search
    @result = Place.where("name LIKE ?","%#{params[:query]}%").paginate(:page => params[:page], :per_page => 8).order("created_at DESC")
  end
  
  # END 
  
  # TIMETABLE
  def timetable
    unless user_signed_in? then
      unauthorized
    else
      exists = Timetable.where(user_id: current_user.id).count
      unless exists == 0 then
        unauthorized
      end
    end
  end
  
  def timetable_edit
    if user_signed_in? then
      @timetable = Timetable.where(user_id: current_user.id)
      unless @timetable.count == 0 then
        @timetable_msg = false
        @timetable = @timetable.first
        @timetable = [[@timetable.mon_time_09, @timetable.mon_time_10, @timetable.mon_time_11, @timetable.mon_time_12, @timetable.mon_time_13, @timetable.mon_time_14, @timetable.mon_time_15, @timetable.mon_time_16, @timetable.mon_time_17, @timetable.mon_time_18, @timetable.mon_time_19],
                      [@timetable.tue_time_09, @timetable.tue_time_10, @timetable.tue_time_11, @timetable.tue_time_12, @timetable.tue_time_13, @timetable.tue_time_14, @timetable.tue_time_15, @timetable.tue_time_16, @timetable.tue_time_17, @timetable.tue_time_18, @timetable.tue_time_19],
                      [@timetable.wed_time_09, @timetable.wed_time_10, @timetable.wed_time_11, @timetable.wed_time_12, @timetable.wed_time_13, @timetable.wed_time_14, @timetable.wed_time_15, @timetable.wed_time_16, @timetable.wed_time_17, @timetable.wed_time_18, @timetable.wed_time_19],
                      [@timetable.thu_time_09, @timetable.thu_time_10, @timetable.thu_time_11, @timetable.thu_time_12, @timetable.thu_time_13, @timetable.thu_time_14, @timetable.thu_time_15, @timetable.thu_time_16, @timetable.thu_time_17, @timetable.thu_time_18, @timetable.thu_time_19],
                      [@timetable.fri_time_09, @timetable.fri_time_10, @timetable.fri_time_11, @timetable.fri_time_12, @timetable.fri_time_13, @timetable.fri_time_14, @timetable.fri_time_15, @timetable.fri_time_16, @timetable.fri_time_17, @timetable.fri_time_18, @timetable.fri_time_19]
                      ]
        
        @mon = Array.new
        @tue = Array.new
        @wed = Array.new
        @thu = Array.new
        @fri = Array.new
        
        @timetable[0].each do |mon|
          @mon << timeType(mon)
        end
        
        @timetable[1].each do |tue|
          @tue << timeType(tue)
        end
        
        @timetable[2].each do |wed|
          @wed << timeType(wed)
        end
        
        @timetable[3].each do |thu|
          @thu << timeType(thu)
        end
        
        @timetable[4].each do |fri|
          @fri << timeType(fri)
        end
      end
    else
      unauthorized
    end
  end
  
  def timetable_edit_exec
    
    if user_signed_in? then
      if params.has_key?(:edit) then
        timetable = Timetable.where(user_id: current_user.id).first
      else
        timetable = Timetable.new
        timetable.user_id = current_user.id
      end
      
      timetable.mon_time_09 = params[:mon][:time_09]
      timetable.mon_time_10 = params[:mon][:time_10]
      timetable.mon_time_11 = params[:mon][:time_11]
      timetable.mon_time_12 = params[:mon][:time_12]
      timetable.mon_time_13 = params[:mon][:time_13]
      timetable.mon_time_14 = params[:mon][:time_14]
      timetable.mon_time_15 = params[:mon][:time_15]
      timetable.mon_time_16 = params[:mon][:time_16]
      timetable.mon_time_17 = params[:mon][:time_17]
      timetable.mon_time_18 = params[:mon][:time_18]
      timetable.mon_time_19 = params[:mon][:time_19]
      
      timetable.tue_time_09 = params[:tue][:time_09]
      timetable.tue_time_10 = params[:tue][:time_10]
      timetable.tue_time_11 = params[:tue][:time_11]
      timetable.tue_time_12 = params[:tue][:time_12]
      timetable.tue_time_13 = params[:tue][:time_13]
      timetable.tue_time_14 = params[:tue][:time_14]
      timetable.tue_time_15 = params[:tue][:time_15]
      timetable.tue_time_16 = params[:tue][:time_16]
      timetable.tue_time_17 = params[:tue][:time_17]
      timetable.tue_time_18 = params[:tue][:time_18]
      timetable.tue_time_19 = params[:tue][:time_19]
      
      timetable.wed_time_09 = params[:wed][:time_09]
      timetable.wed_time_10 = params[:wed][:time_10]
      timetable.wed_time_11 = params[:wed][:time_11]
      timetable.wed_time_12 = params[:wed][:time_12]
      timetable.wed_time_13 = params[:wed][:time_13]
      timetable.wed_time_14 = params[:wed][:time_14]
      timetable.wed_time_15 = params[:wed][:time_15]
      timetable.wed_time_16 = params[:wed][:time_16]
      timetable.wed_time_17 = params[:wed][:time_17]
      timetable.wed_time_18 = params[:wed][:time_18]
      timetable.wed_time_19 = params[:wed][:time_19]
      
      timetable.thu_time_09 = params[:thu][:time_09]
      timetable.thu_time_10 = params[:thu][:time_10]
      timetable.thu_time_11 = params[:thu][:time_11]
      timetable.thu_time_12 = params[:thu][:time_12]
      timetable.thu_time_13 = params[:thu][:time_13]
      timetable.thu_time_14 = params[:thu][:time_14]
      timetable.thu_time_15 = params[:thu][:time_15]
      timetable.thu_time_16 = params[:thu][:time_16]
      timetable.thu_time_17 = params[:thu][:time_17]
      timetable.thu_time_18 = params[:thu][:time_18]
      timetable.thu_time_19 = params[:thu][:time_19]
      
      timetable.fri_time_09 = params[:fri][:time_09]
      timetable.fri_time_10 = params[:fri][:time_10]
      timetable.fri_time_11 = params[:fri][:time_11]
      timetable.fri_time_12 = params[:fri][:time_12]
      timetable.fri_time_13 = params[:fri][:time_13]
      timetable.fri_time_14 = params[:fri][:time_14]
      timetable.fri_time_15 = params[:fri][:time_15]
      timetable.fri_time_16 = params[:fri][:time_16]
      timetable.fri_time_17 = params[:fri][:time_17]
      timetable.fri_time_18 = params[:fri][:time_18]
      timetable.fri_time_19 = params[:fri][:time_19]
      
      if timetable.save then
        flash[:created] = "시간표 데이터가 저장되었습니다."
        redirect_to mypage_path
      else
        error_occurred
      end
    else
      unauthorized
    end
    
  end
  # END
  
  # RESERVATIONS
  def reservations
    if user_signed_in? then
      @groupInfo = Group.find(Reservation.find(params[:resv_id]).group_id)
      @placeInfo = Place.find(Reservation.find(params[:resv_id]).place_id)
      @resvInfo = Reservation.find(params[:resv_id])
    elsif owner_signed_in? then
      @groupInfo = Group.find(Reservation.find(params[:resv_id]).group_id)
      @placeInfo = Place.find(Reservation.find(params[:resv_id]).place_id)
      @resvInfo = Reservation.find(params[:resv_id])
    else
      unauthorized
    end
  end
  
  def resv_search
    schedule = "#{params[:when]} #{params[:schedule]}"
    duration = "#{params[:when]} #{params[:duration]}"
    query = Reservation.where("place_id = ? AND schedule LIKE ? AND duration LIKE ?", params[:pid],"%#{schedule}%","%#{duration}%")
    if query.count == 0 then
      open = Place.find(params[:pid]).open.to_i
      close = Place.find(params[:pid]).close.to_i
      schedule = params[:schedule][0..1]
      duration = params[:duration][0..1]
      if open > schedule.to_i or close < schedule.to_i or close < duration.to_i then
        result = false
      else
        result = true
      end
    else
      result = false
    end
    respond_to do |format|
       format.json { 
          render json: {:isAvailable => result}
       }
    end
  end
  
  def reservations_cancel
    if user_signed_in? then
      if Reservation.find(params[:resv_id]).delete then
        flash[:cancelled]="예약 취소가 완료되었습니다."
        redirect_to mypage_path
      else
        error_occurred
      end
    elsif owner_signed_in? then
      if Reservation.find(params[:resv_id]).delete then
        flash[:cancelled]="예약 취소가 완료되었습니다."
        redirect_to mypage_path
      else
        error_occurred
      end
    else
      unauthorized
    end
  end
  
  def reservations_confirm
   if owner_signed_in? then
      @reservation = Reservation.find(params[:resv_id])
      @reservation.confirm = 1
      if @reservation.save then
        flash[:succeess] = "예약 완료되었습니다."
        redirect_to mypage_path
      end
    else
      unauthorized
    end
  end
  # END
  
  # MEMBER OUT
  def member_out
    if user_signed_in? then
      g = Group.find(params[:group_id])
      g.affiliation = g.affiliation.gsub(params[:member_info] + '|', "")
      g.member = g.member + 1
      if g.save then
        flash[:success] = "멤버를 그룹에서 제외시켰습니다."
        redirect_to "/find/group/detail/"+params[:group_id]
      else
        error_occurred
      end
    else
      unauthorized
    end
  end
  # END
  
  private
 
  # CHECK SIGNED IN FOR USING THE SERVICE
  def require_login
    unless user_signed_in? || owner_signed_in?
      flash[:error] = "서비스 이용을 위한 로그인이 필요합니다."
      redirect_to login_path # halts request cycle
    end
  end
  
  def unauthorized
    flash[:authorization] = "잘못된 접근입니다."
    redirect_to mypage_path
  end
  
  def error_occurred
      flash[:error] = "에러가 발생하였습니다."
      redirect_to mypage_path
  end
  
  def timeType(array)
    case array
    when ["2","2","2","2"]
      return 1
    when ["2","1","2","2"]
      return 2
    when ["2","2","2","1"]
      return 3
    when ["2","1","1","1"]
      return 4
    when ["1","1","1","1"]
      return 5
    when ["1","1","2","2"]
      return 6
    else
      return 7
    end
  end
  
  def whenTogether(array)
    mon = Array.new(11){Array.new(array.size)}
    tue = Array.new(11){Array.new(array.size)}
    wed = Array.new(11){Array.new(array.size)}
    thu = Array.new(11){Array.new(array.size)}
    fri = Array.new(11){Array.new(array.size)}
    
    times = Array.new(5){Array.new(11)}
    
    i = 0
    array.each do |a|
      mon[0][i] = Timetable.where(user_id: a).first.mon_time_09
      mon[1][i] = Timetable.where(user_id: a).first.mon_time_10
      mon[2][i] = Timetable.where(user_id: a).first.mon_time_11
      mon[3][i] = Timetable.where(user_id: a).first.mon_time_12
      mon[4][i] = Timetable.where(user_id: a).first.mon_time_13
      mon[5][i] = Timetable.where(user_id: a).first.mon_time_14
      mon[6][i] = Timetable.where(user_id: a).first.mon_time_15
      mon[7][i] = Timetable.where(user_id: a).first.mon_time_16
      mon[8][i] = Timetable.where(user_id: a).first.mon_time_17
      mon[9][i] = Timetable.where(user_id: a).first.mon_time_18
      mon[10][i] = Timetable.where(user_id: a).first.mon_time_19
      
      tue[0][i] = Timetable.where(user_id: a).first.tue_time_09
      tue[1][i] = Timetable.where(user_id: a).first.tue_time_10
      tue[2][i] = Timetable.where(user_id: a).first.tue_time_11
      tue[3][i] = Timetable.where(user_id: a).first.tue_time_12
      tue[4][i] = Timetable.where(user_id: a).first.tue_time_13
      tue[5][i] = Timetable.where(user_id: a).first.tue_time_14
      tue[6][i] = Timetable.where(user_id: a).first.tue_time_15
      tue[7][i] = Timetable.where(user_id: a).first.tue_time_16
      tue[8][i] = Timetable.where(user_id: a).first.tue_time_17
      tue[9][i] = Timetable.where(user_id: a).first.tue_time_18
      tue[10][i] = Timetable.where(user_id: a).first.tue_time_19
      
      wed[0][i] = Timetable.where(user_id: a).first.wed_time_09
      wed[1][i] = Timetable.where(user_id: a).first.wed_time_10
      wed[2][i] = Timetable.where(user_id: a).first.wed_time_11
      wed[3][i] = Timetable.where(user_id: a).first.wed_time_12
      wed[4][i] = Timetable.where(user_id: a).first.wed_time_13
      wed[5][i] = Timetable.where(user_id: a).first.wed_time_14
      wed[6][i] = Timetable.where(user_id: a).first.wed_time_15
      wed[7][i] = Timetable.where(user_id: a).first.wed_time_16
      wed[8][i] = Timetable.where(user_id: a).first.wed_time_17
      wed[9][i] = Timetable.where(user_id: a).first.wed_time_18
      wed[10][i] = Timetable.where(user_id: a).first.wed_time_19

      thu[0][i] = Timetable.where(user_id: a).first.thu_time_09
      thu[1][i] = Timetable.where(user_id: a).first.thu_time_10
      thu[2][i] = Timetable.where(user_id: a).first.thu_time_11
      thu[3][i] = Timetable.where(user_id: a).first.thu_time_12
      thu[4][i] = Timetable.where(user_id: a).first.thu_time_13
      thu[5][i] = Timetable.where(user_id: a).first.thu_time_14
      thu[6][i] = Timetable.where(user_id: a).first.thu_time_15
      thu[7][i] = Timetable.where(user_id: a).first.thu_time_16
      thu[8][i] = Timetable.where(user_id: a).first.thu_time_17
      thu[9][i] = Timetable.where(user_id: a).first.thu_time_18
      thu[10][i] = Timetable.where(user_id: a).first.thu_time_19
      
      fri[0][i] = Timetable.where(user_id: a).first.fri_time_09
      fri[1][i] = Timetable.where(user_id: a).first.fri_time_10
      fri[2][i] = Timetable.where(user_id: a).first.fri_time_11
      fri[3][i] = Timetable.where(user_id: a).first.fri_time_12
      fri[4][i] = Timetable.where(user_id: a).first.fri_time_13
      fri[5][i] = Timetable.where(user_id: a).first.fri_time_14
      fri[6][i] = Timetable.where(user_id: a).first.fri_time_15
      fri[7][i] = Timetable.where(user_id: a).first.fri_time_16
      fri[8][i] = Timetable.where(user_id: a).first.fri_time_17
      fri[9][i] = Timetable.where(user_id: a).first.fri_time_18
      fri[10][i] = Timetable.where(user_id: a).first.fri_time_19
      
      i = i + 1
    end
    
    ## Find optimal time the group can be gathered
    0.upto(10) do |index|
      if mon[index].uniq.count == 1 and mon[index].uniq.include? ["1","1","1","1"] then
        times[0][index] = "ABLE"
      end
      if tue[index].uniq.count == 1 and tue[index].uniq.include? ["1","1","1","1"] then
        times[1][index] = "ABLE"
      end
      if wed[index].uniq.count == 1 and wed[index].uniq.include? ["1","1","1","1"] then
        times[2][index] = "ABLE"
      end
      if thu[index].uniq.count == 1 and thu[index].uniq.include? ["1","1","1","1"] then
        times[3][index] = "ABLE"
      end
      if fri[index].uniq.count == 1 and fri[index].uniq.include? ["1","1","1","1"] then
        times[4][index] = "ABLE"
      end
    end
    ## END
    return times
  end
  
end