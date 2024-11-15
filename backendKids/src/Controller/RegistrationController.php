<?php

namespace App\Controller;

use App\Entity\Coach;
use App\Entity\Kid;
use App\Entity\User;
use App\Form\RegistrationFormType;
use Doctrine\ORM\EntityManagerInterface;
use Nelmio\ApiDocBundle\Annotation\Model;
use Symfony\Bundle\FrameworkBundle\Controller\AbstractController;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\PasswordHasher\Hasher\UserPasswordHasherInterface;
use Symfony\Component\Routing\Attribute\Route;
use OpenApi\Attributes as OA;
use Symfony\Component\HttpFoundation\JsonResponse;

#[Route('/api')]
class RegistrationController extends AbstractController
{
    #[Route('/register', name: 'app_register', methods: ['POST'])]
    #[OA\RequestBody(content: new Model(type: RegistrationFormType::class))]
    #[OA\Response(
        response: 200,
        description: 'User successfully registered',
        content: new OA\JsonContent(
            type: 'object',
            properties: [
                new OA\Property(property: 'message', type: 'string')
            ]
        )
    )]
    #[OA\Tag(name: 'Registration')]
    public function register(Request $request, UserPasswordHasherInterface $userPasswordHasher, EntityManagerInterface $entityManager): JsonResponse
    {

        $data = json_decode($request->getContent(), true);
        $form = $this->createForm(RegistrationFormType::class);
        $form->submit($data);

        if ($data === null) {
            return new JsonResponse(['message' => 'Invalid JSON data']);
        }

        $user = new Kid();

        $user->setFullName($data['fullName']);
        $user->setEmail($data['email']);

        $user->setPassword(
            $userPasswordHasher->hashPassword(
                $user,
                $data['plainPassword']
            )
        );
        $user->setBirthDate(!empty($data['birthDate']) ? new \DateTimeImmutable($data['birthDate']) : null);
        $user->setRegistrationDate(new \DateTime());
        $user->setGender($data['gender']);

        $entityManager->persist($user);
        $entityManager->flush();
        return new JsonResponse(["success" => true]);
    }

    #[Route('/registerAdmin', name: 'app_register_admin', methods: ['POST'])]
    #[OA\RequestBody(content: new Model(type: RegistrationFormType::class))]
    #[OA\Response(
        response: 200,
        description: 'User successfully registered',
        content: new OA\JsonContent(
            type: 'object',
            properties: [
                new OA\Property(property: 'message', type: 'string')
            ]
        )
    )]
    #[OA\Tag(name: 'Registration')]
    public function registerAdmin(Request $request, UserPasswordHasherInterface $userPasswordHasher, EntityManagerInterface $entityManager): JsonResponse
    {

        $data = json_decode($request->getContent(), true);

        if ($data === null) {
            return new JsonResponse(['message' => 'Invalid JSON data']);
        }

        $user = new User();

        $user->setFullName($data['fullName']);
        $user->setEmail($data['email']);
        if ($data['plainPassword'] != $data['confirmPassword']) {
            return new JsonResponse(['message' => 'Passwords dont match']);
        }

        $user->setPassword(
            $userPasswordHasher->hashPassword(
                $user,
                $data['plainPassword']
            )
        );

        $user->setRegistrationDate(new \DateTime());

        $entityManager->persist($user);
        $entityManager->flush();

        return new JsonResponse(["success" => true]);
    }
}
