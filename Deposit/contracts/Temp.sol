pragma solidity >=0.5.0 <0.6.0;



contract Deposit{
    
address admin;//генезис, первый пользователь
address[] public participants;// кол-во участников в системе или депозитов


mapping (address => uint) public refbonus;// базовый реферальный бонус
mapping (uint => uint) public refbonus2; // расширенный реферальный бонус co 2 линии
mapping (uint => uint) public refbonus3; // расширенный реферальный бонус c 3 линии
mapping (uint => uint) public refbonus4; // расширенный реферальный бонус c 4 линии
mapping (address => TimeLine) public lines; // номер линии пользователя

mapping (address => uint) public More10Ref; // количество прямых рефералов

struct TimeLine{
    uint line;// number of line in struct of piramid
    uint time;
}    
 

// конструктор

constructor() public {
admin = msg.sender;
lines[admin].line = 0 ;

}


// Прием депозитов

function deposit(address _referrer) public payable {
    //require (_referrer != address (0) && msg.sender != admin && msg.sender != _referrer && msg.value >= 0.01 ether);
    
    refbonus [_referrer] += msg.value *  5 / 100;
    More10Ref[_referrer] += 1;
    
        if (lines [msg.sender].line == 0){   // для новых пользователей
        lines [msg.sender].line = lines [_referrer].line + 1;
        lines [msg.sender].time = now;
        
        }
    refbonus2 [lines[msg.sender].line + 1] += msg.value *  3 / 100;
    refbonus3 [lines[msg.sender].line + 2] += msg.value *  1 / 100;
    refbonus4 [lines[msg.sender].line + 3] += msg.value *  5 / 1000;    
    
    
    
    participants.push(msg.sender);
    
    
    }
    
// Подсчет реферальных бонусов в разрезе каждого участника

function GetBonus() public {
    
    uint bonus = refbonus [msg.sender];
    refbonus [msg.sender] = 0;
    
    uint addbonus;
        
        if (More10Ref[msg.sender] > 10 && participants.length > 50 && lines [msg.sender].time + 14 days <= now){
       
    
        addbonus = refbonus2[lines[msg.sender].line + 1] + refbonus3[lines[msg.sender].line + 2] + refbonus3[lines[msg.sender].line +3]+  refbonus3[lines[msg.sender].line +4] ;
        
        refbonus2[lines[msg.sender].line + 1] = 0;
        refbonus3[lines[msg.sender].line + 2] = 0;   
        refbonus3[lines[msg.sender].line + 3] = 0;
        refbonus3[lines[msg.sender].line + 4] = 0;
        }
        
        
    bonus += addbonus;
    
    msg.sender.transfer(bonus);    
        
    }  
}

    
    



