function hist = aibcuthist(map, x, varargin)
% AIBCUTHIST  Compute histogram over AIB cut
%  HIST = AIBCUTHIST(MAP, X) computes the histogram of the data X over
%  the specified AIB cut MAP (as returned by AIBCUT()).  Each element
%  of hist counts how many elements of X are projected in the
%  corresponding cut node.
%
%  Data are mapped to bins as specified by AIBCUTPUSH(). Data mapped
%  to the null node are dropped.
%
%  Options:
%    Nulls [drop]
%      What to do of null nodes: drop ('drop'), accumulate to an
%      extra bin at the end of HIST ('append'), or accumulate to
%      the first bin ('first')

% AUTORIGHTS

mode = 'drop' ;

for k=1:2:length(varargin)
  opt=varargin{k} ;
  arg=varargin{k+1} ;
  switch lower(opt)
    case 'nulls'
      switch lower(arg)
        case 'drop'
          mode = 'drop' ;
        case 'append'
          mode = 'append' ;
        case 'first'
          mode = 'first' ;
        otherwise
          error(sprintf('Illegal argument ''%s'' for ''Nulls''', arg)) ;
      end
    otherwise
      error(sprintf('Unknown option ''%''', opt)) ;
  end
end

% determine cut size
cut_size = max(map) ;

% relabel data
y = aibcutpush(map, x) ;

% null?
if any(y == 0)
  switch mode
    case 'drop'
      y = y(y ~= 0) ;
    case 'append'
      cut_size = cut_size + 1 ;
      y(y == 0) = cut_size ;
    case 'first'
      y(y == 0) = 1 ;
  end
end

% Now we have the nodes of the cut. Accumulate.
hist = zeros(1, cut_size) ;
hist = binsum(hist, ones(size(y)), y) ;
