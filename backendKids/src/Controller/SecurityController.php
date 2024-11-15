<?php

namespace App\Controller;

use Gesdinet\JWTRefreshTokenBundle\Generator\RefreshTokenGeneratorInterface;
use Gesdinet\JWTRefreshTokenBundle\Model\RefreshTokenManagerInterface;
use Lexik\Bundle\JWTAuthenticationBundle\Services\JWTTokenManagerInterface;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\JsonResponse;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Attribute\Route;
use Symfony\Component\Security\Core\User\UserInterface;
use Symfony\Component\Security\Http\Authentication\AuthenticationUtils;
use OpenApi\Attributes as OA;
use OpenApi\Examples\Polymorphism\Request;
use App\Repository\UserRepository;
use App\Service\UserService;
use Symfony\Bundle\SecurityBundle\Security;
use App\Entity\User;


#[Route('/api')]
class SecurityController extends AbstractController
{
    private $jwtManager;
    private $refreshTokenManager;
    private $security;
    private $userService;

    public function __construct(JWTTokenManagerInterface $jwtManager, RefreshTokenManagerInterface $refreshTokenManager, Security $security, UserService $userService)
    {
        $this->jwtManager = $jwtManager;
        $this->refreshTokenManager = $refreshTokenManager;
        $this->security = $security;
        $this->userService = $userService;
    }

    #[Route(path: '/login_check', name: 'app_login_check', methods: ['POST'])]
    #[OA\RequestBody(
        required: true,
        content: new OA\JsonContent(
            type: Object::class,
            example: [
                "email" => "test.test@test.com",
                "password" => "test"
            ]
        )
    )]
    public function login(AuthenticationUtils $authenticationUtils): Response
    {
        $error = $authenticationUtils->getLastAuthenticationError();
        // $lastUsername = $authenticationUtils->getLastUsername();

        if ($error) {
            return new JsonResponse(['error' => $error->getMessageKey()], Response::HTTP_UNAUTHORIZED);
        }

        $user = $this->getUser();

        if (!$user instanceof UserInterface) {
            return new JsonResponse(['error' => 'Invalid login credentials'], Response::HTTP_UNAUTHORIZED);
        }

        $token = $this->jwtManager->create($user);
        $refreshToken = $this->refreshTokenManager->create($user);
        $role = $user->getRoles();
        return new JsonResponse(['authToken' => $token, 'refreshToken' => $refreshToken]);
    }

    #[Route(path: '/logout', name: 'app_logout', methods: ['POST'])]
    public function logout(): void
    {
        throw new \LogicException('This method can be blank - it will be intercepted by the logout key on your firewall.');
    }
    #[Route('/profile', name: 'user_profile', methods: ['GET'])]
    public function showProfile(UserRepository $userRepository): JsonResponse
    {
        $user = $this->security->getUser();
        if (!$user instanceof User) {
            return new JsonResponse(['error' => 'User not authenticated']);
        }
        $user = $userRepository->find($user->getId());
        if (!$user) {
            return new JsonResponse(['error' => 'user not found']);
        }
        $userData = $this->userService->userToJson($user);
        return new JsonResponse($userData);
    }
}
