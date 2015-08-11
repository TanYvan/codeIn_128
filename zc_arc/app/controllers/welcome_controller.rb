require 'digest/sha1'
class WelcomeController < ApplicationController
  def login
    
  end
  def login_do
    code=params[:code]
    password=params[:password]
    #u=User.find(:all,:conditions=>["code=? and password=? and states='Y'",code,password])
    u=User.find(:first,:conditions=>["code=? and used='Y'",code])
    err=0
    if u==nil
      err=1
    else
      if u.password==Digest::SHA1.hexdigest(password)
        err=0
      else
        err=1
      end
    end
    if err==1
      flash[:login]="登录失败，用户名或密码错误。"
      render :action => 'login'
    else
      u=User.find_by_code(code)
      session[:user_code]=u.code
      session[:user_name]=u.name
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0001'",u.code]).empty?
        session["0001"]='N' #0001代表处长
      else
        session["0001"]='Y'
      end
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0003'",u.code]).empty?
        session["0003"]='N' #0003代表仲裁助理
      else
        session["0003"]='Y'
      end
      lines=SysArg.find_by_code('9003')
      if lines!=nil
        session[:lines]=lines.val  
      else
        session[:lines]='20'
      end
      #判断用户档案修改的权限范围
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='1002'",u.code]).empty?
        if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='1001'",u.code]).empty?
          session[:chang]='0'
        else
          session[:chang]='1'
        end
      else
        session[:chang]='2'
      end
      redirect_to :action=>"main"
    end
    
  end
  
  def logout
      session[:user_code]=nil
      session[:user_name]=nil
      session["0001"]=nil
      session["0003"]=nil
      session[:lines]=nil
      session[:case_code]=nil
      session[:recevice_code]=nil
      session[:general_code]=nil
      render :action => 'login'
  end
  def change_password
      @user=User.find_by_code(session[:user_code])
      @user.password=""
      
  end
  def change_password_do
      @user=User.find_by_code(session[:user_code])
      if @user.password==Digest::SHA1.hexdigest(params[:old_password])
        @user.password=Digest::SHA1.hexdigest(params[:user][:password])
        if @user.save
          render :text=>"密码修改成功！"
        else
          render :text=>"密码修改失败！"
        end
      else
        render :text=>"原密码输入错误！"
      end
  end
  def main
    
  end
  
  def top
#    @page=action_name
#    session[:subject_code]=params[:sub]
    @f=FastMenu.find_by_sql("select fast_menus.name as name,fast_menus.menu_id as menu_id,
    fast_menus.url as url from fast_menus where fast_menus.role_code in
    (select role_code from urs where fast_menus.role_code='9901' and urs.user_code='#{session[:user_code]}' )
    order by fast_menus.role_code,fast_menus.code")
  end
  
  def right
    
  end

  def login_do_2
    code=params[:c]
    password=params[:p]
    #u=User.find(:all,:conditions=>["code=? and password=? and states='Y'",code,password])
    u=User.find(:first,:conditions=>["code=? and used='Y'",code])
    err=0
    if u==nil
      err=1
    else
      if PubTool.new.p_en(u.password)==password
        err=0
      else
        err=1
      end
    end
    if err==1
      flash[:login]="登录失败，用户名或密码错误。"
      render :action => 'login'
    else
      u=User.find_by_code(code)
      session[:user_code]=u.code
      session[:user_name]=u.name
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0001'",u.code]).empty?
        session["0001"]='N' #0001代表处长
      else
        session["0001"]='Y'
      end
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='0003'",u.code]).empty?
        session["0003"]='N' #0003代表仲裁助理
      else
        session["0003"]='Y'
      end
      lines=SysArg.find_by_code('9003')
      if lines!=nil
        session[:lines]=lines.val  
      else
        session[:lines]='20'
      end
      @case=TbCase.find_by_recevice_code(params[:recevice_code])
      if @case!=nil
        session[:case_code]=@case.case_code
        session[:recevice_code]=@case.recevice_code
        session[:general_code]=@case.general_code
      end
      #判断用户档案修改的权限范围
      if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='1002'",u.code]).empty?
        if UserDuty.find_by_sql(["select * from user_duties where user_code=? and duty_code='1001'",u.code]).empty?
          session[:chang]='0'
        else
          session[:chang]='1'
        end
      else
        session[:chang]='2'
      end
      redirect_to :action=>"main",:page=>"/casebase/list"
    end
    
  end

end
