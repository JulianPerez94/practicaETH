pragma solidity ^0.4.26;

contract Tarea_lottery {
    
    struct lotteryData{
        string nombre;
        uint  maxNumberParticipants;
        uint  participationPrice;
        uint  participationPot;
        bool  status;
        string  statusActual;
        address manager; 
        uint ticketsBought;
        address[] participants;
    }
    address creador;
   
// aux state Lottery
    bool  statusLot;
    bool  statusLimPart;
    bool  statusLimBet;
    bool  statusDecWin;    
    
 //   address[]  lotteries;
    
  //  string lotteryAddress;// deber ser tipo address

    struct PlayerConfig{
        string PlayerName;
        uint PlayerCounter;
        uint PlayerIndex;
    }
    
    address[] public addressIndexes;
    address[] public lotteryBag;  // ¿?
    
  //  mapping(address => LotteryConfig) LottoBets;
   mapping(address => PlayerConfig) Users;
   mapping(address => lotteryData) Lotteries; 
   
    
    constructor(string _name, address _creator, uint _price, uint _maxplayers ,uint _pot) public{
        require(bytes(_name).length > 0);
        creador= _creator;
        Lotteries[_creator].nombre = _name;
        Lotteries[_creator].manager = _creator;
        Lotteries[_creator].maxNumberParticipants = _maxplayers;
        Lotteries[_creator].participationPrice = _price;
        Lotteries[_creator].participationPot = _pot;
        Lotteries[_creator].status = true ;
        Lotteries[_creator].statusActual = StateLottery();
        Lotteries[_creator].ticketsBought = 0 ;
        statusLot = true;
        statusLimPart = false; 
        statusLimBet = false; 
        statusDecWin = false;
        //lotteryAddress = lotteryAddress.push(msg.transact) - 1; //0xf075493c2f67db0085bbef1f8c75d6c013bc8bee
                ////lotteryAddress = lotteryAddress.push(msg.transact) - 1; //0xf075493c2f67db0085bbef1f8c75d6c013bc8bee
        //  if (isNewLottery(_name)) {
        //       Lotteries[_creator].nombre = _name;
        //       Lotteries[_creator].manager = _creator;
        //       Lotteries[_creator].maxNumberParticipants = _maxplayers;
        //       Lotteries[_creator].participationPrice = _price/ 1 ether;
        //       Lotteries[_creator].participationPot = _pot/ 1 ether;
        //       Lotteries[_creator].status = true ;
          
        //  } else {
        //       Lotteries[_creator].nombre = addressIndexes.push(_name) ;
        //       Lotteries[_creator].[manager].push(_creator);
        //       Lotteries[_creator].maxNumberParticipants.push(_maxplayers);
        //       Lotteries[_creator].participationPrice.push(_price/ 1 ether);
        //       Lotteries[_creator].participationPot.push(_pot/ 1 ether);
        //       Lotteries[_creator].status = true ;
        //  }
    }
    
    // -----------------------------Modifiers-------------------------------//
    
    modifier onlyOwner() {
        require(msg.sender == Lotteries[creador].manager, "Ownable: caller is not the owner");
        _;
    }
    
    //Lottery is created by true status and will be changed to false at Lottery`s ending.
    modifier IsActive() {
        require(Lotteries[creador].status == true, "Lottery isn`t available");
        _;
    }
    
    //Lottery evaluates that the number of ticket sold is higher than participants
    modifier allTicketsSold() {
      require(Lotteries[creador].ticketsBought >= Lotteries[creador].maxNumberParticipants);
      _;
    }
    
    //-------------------------------Events------------------------------------//
    
    event PlayerParticipated( string name, uint entryCount );

    // -----------------------------Functions---------------------------------//
    
    // Let users participate by sending eth directly to contract address
    function () public payable {
    // player name will be unknown
        AddParticipants("Unknown");
    }

    function AddParticipants(string _player) public IsActive payable  {
        require(bytes(_player).length > 0, "Insert a player");
        require(msg.value == Lotteries[creador].participationPrice * 1 wei , "Participation amount isn´t right");
        require(Users[msg.sender].PlayerCounter < 1, "Too Much entries for player");
        require(Lotteries[creador].maxNumberParticipants >= Lotteries[creador].ticketsBought);
        
            statusLimPart = true; // falta condicionarlo para cuando se alcance el max de participantes
            statusLimBet = true; // falta condicionarlo para cuando se alcance el max del bote
            statusDecWin = false; // esto iria al momento de sortear la loteria como true
            Lotteries[creador].statusActual = StateLottery();
            
        if (isNewPlayer(msg.sender)) {
            Users[msg.sender].PlayerCounter = 1;
            Users[msg.sender].PlayerName = _player;
            Users[msg.sender].PlayerIndex = addressIndexes.push(msg.sender) - 1;
        
        } else {
            Users[msg.sender].PlayerCounter = 1;
        }
        
        Lotteries[creador].ticketsBought += 1;
        lotteryBag.push(msg.sender);
    
        // event
       emit PlayerParticipated(Users[msg.sender].PlayerName, Users[msg.sender].PlayerCounter);
    }
    
       // Control that the didn´t already exist
    function isNewPlayer(address playerAddress) private view returns(bool) {
        if (addressIndexes.length == 0) {
            return true;
        }
        return (addressIndexes[Users[playerAddress].PlayerIndex] != playerAddress);
    }
    
    function isNewLottery(string memory _nameLottery) public view returns(bool) {
        return keccak256(abi.encodePacked(Lotteries[creador].nombre)) == keccak256(abi.encodePacked(_nameLottery));
     }
    
    function getLottery(string memory _nameLottery) public view returns (string, address, uint, uint ,uint , string ) { 
        //require(bytes(Lotteries[creador].nombre).length > 0);
        StateLottery() ;
        require(keccak256(abi.encodePacked(Lotteries[creador].nombre)) == keccak256(abi.encodePacked(_nameLottery)));
        return (Lotteries[creador].nombre,Lotteries[creador].manager, Lotteries[creador].maxNumberParticipants, 
                Lotteries[creador].participationPrice, Lotteries[creador].participationPot, Lotteries[creador].statusActual );
    }
    
    
     function getLotteries() public view returns (string) {
      return (Lotteries[creador].nombre);
    }
    
    function getParticipants() public view returns (address[]) {
      return (addressIndexes);
    }
    

    // Función aleatoria. Le pasamos un string y con la función keccak256 (SHA3) genera un número que 
    //transformamos en un número entre 1 y el número de participantes, que será el ganador del premio
    function ruffle (uint _maxNumberParticipants ) onlyOwner public view  returns (uint) {
        return uint (keccak256(abi.encodePacked(block.difficulty, now))) % _maxNumberParticipants ;
    }
    
     function StateLottery() private view returns (string) {
         if (statusLot != true && statusLimPart == false  && statusLimBet == false ) {
             return ('activo');
            }
         if (statusLot != true && statusLimPart == true  && statusLimBet == false ) {
             return ('anulada');
            }
         if (statusLot != true  && statusLimBet == true ) {
             return ('cerrada');
            }
         if (statusLot != true  && statusLimBet == true && statusDecWin ==true ) {
             return ('terminada');
            }
    }
    

}

